package generator

import (
	"fmt"
	"testing"
	"time"

	"github.com/raibru/gobooklet/datatypes"
)

// TestGenerateYearDays prüft die korrekte Anzahl der Tage und Schlüsseldaten für ein Schaltjahr und ein normales Jahr.
func TestGenerateYearDays(t *testing.T) {
	//t.Error("Check test failure")

	// Test 1: Normales Jahr (2025 -> 365 Tage)
	days2025 := GenerateYearDays(2025)
	if len(days2025) != 365 {
		t.Errorf("Erwartet 365 Tage für 2025, got: %d", len(days2025))
	}

	// Test 2: Schaltjahr (2024 -> 366 Tage)
	days2024 := GenerateYearDays(2024)
	if len(days2024) != 366 {
		t.Errorf("Erwartet 366 Tage für 2024 (Schaltjahr), got: %d", len(days2024))
	}

	// Test 3: Stichprobenprüfung für den 1. Januar 2026
	days2026 := GenerateYearDays(2026)
	jan1 := days2026[0]

	if jan1.MonthNumber != 1 {
		t.Errorf("Erwartete Monatsnummer 1, got: %d", jan1.MonthNumber)
	}
	if jan1.MonthName != "Januar" {
		t.Errorf("Erwarteter Monatsname 'Januar', got: '%s'", jan1.MonthName)
	}
	if jan1.DayOfMonth != 1 {
		t.Errorf("Erwarteter Tag 1, got: %d", jan1.DayOfMonth)
	}
	if jan1.WeekdayName != "Donnerstag" {
		t.Errorf("Erwarteter Wochentag 'Donnerstag' am 01.01.2026, got: '%s'", jan1.WeekdayName)
	}
	if jan1.ISOWeek != 1 {
		t.Errorf("Erwartete ISO-Kalenderwoche 1, got: %d", jan1.ISOWeek)
	}
}

// TestISOWeekBoundary prüft Spezialfälle an den Jahresgrenzen nach ISO 8601.
func TestISOWeekBoundary(t *testing.T) {
	//t.Error("Check test failure")

	// Der 31.12.2019 gehört laut ISO 8601 bereits zur KW 1 des Jahres 2020
	days2019 := GenerateYearDays(2019)
	dec31 := days2019[len(days2019)-1]

	if dec31.ISOWeek != 1 {
		t.Errorf("Erwartete ISO-KW 1 für den 31.12.2019, got: %d", dec31.ISOWeek)
	}
	if dec31.ISOYear != 2020 {
		t.Errorf("Erwartetes ISO-Jahr 2020 für den 31.12.2019, got: %d", dec31.ISOYear)
	}
}

// TestGenerateFullWeeksForYear prüft, ob Wochen immer am Montag beginnen und am Sonntag enden,
// sowie ob die Randtage aus dem Vor- und Folgejahr enthalten sind.
func TestGenerateFullWeeksForYear(t *testing.T) {
	//t.Error("Check test failure")
	year := 2026
	days := GenerateFullWeeksForYear(year)

	if len(days) == 0 {
		t.Fatalf("Keine Tage generiert für %d", year)
	}

	// 1. Erster Tag MUSS ein Montag sein
	firstDay := days[0]
	if firstDay.Date.Weekday() != time.Monday {
		t.Errorf("Erster Tag sollte Montag sein, ist aber %s", firstDay.WeekdayName)
	}

	// 2. Letzter Tag MUSS ein Sonntag sein
	lastDay := days[len(days)-1]
	if lastDay.Date.Weekday() != time.Sunday {
		t.Errorf("Letzter Tag sollte Sonntag sein, ist aber %s", lastDay.WeekdayName)
	}

	// 3. Gesamtzahl der Tage muss durch 7 teilbar sein
	if len(days)%7 != 0 {
		t.Errorf("Gesamtzahl der Tage (%d) ist nicht durch 7 teilbar", len(days))
	}

	// 4. Prüfen, ob der 01.01.2026 enthalten ist
	foundJan1 := false
	for _, d := range days {
		if d.Date.Year() == 2026 && d.MonthNumber == 1 && d.DayOfMonth == 1 {
			foundJan1 = true
			break
		}
	}
	if !foundJan1 {
		t.Error("01.01.2026 wurde in der Liste nicht gefunden")
	}

	// 5. Überprüfung der Vorjahr-Tage (Der 01.01.2026 ist ein Donnerstag -> KW 1 beginnt am 29.12.2025)
	if firstDay.Date.Year() != 2025 || firstDay.MonthNumber != 12 || firstDay.DayOfMonth != 29 {
		t.Errorf("Erwartet 29.12.2025 als Wochenstart der ersten KW von 2026, got: %s", firstDay.Date.Format("2006-01-02"))
	}
}

// TestGroupDaysByWeek prüft die Korrektheit der Wochengruppierung.
func TestGroupDaysByWeek(t *testing.T) {
	//t.Error("Check test failure")
	days := GenerateFullWeeksForYear(2026)
	weeks := GroupDaysByWeek(days)

	if len(weeks) == 0 {
		t.Fatalf("Keine Wochen generiert")
	}

	for i, week := range weeks {
		// Jede Woche muss exakt 7 Tage haben
		if len(week.Days) != 7 {
			t.Errorf("Woche %d (KW %02d) hat %d Tage statt 7", i, week.ISOWeek, len(week.Days))
		}

		// Erste Tag der Woche ist Montag, letzter Tag ist Sonntag
		if week.Days[0].Date.Weekday() != time.Monday {
			t.Errorf("Woche %02d beginnt nicht am Montag", week.ISOWeek)
		}
		if week.Days[6].Date.Weekday() != time.Sunday {
			t.Errorf("Woche %02d endet nicht am Sonntag", week.ISOWeek)
		}
	}
}

// TestGroupDaysByMonth prüft die Korrektheit der Monatsgruppierung.
func TestGroupDaysByMonat(t *testing.T) {
	//t.Error("Check test failure")
	testYear := 2026
	days := GenerateFullWeeksForYear(testYear)
	months := GroupDaysByMonth(testYear, days)
	//PrettyPrintGroupedByMonth(testYear, days)

	if len(months) == 0 {
		t.Fatalf("Keine Monate generiert")
	}

	for _, month := range months {
		// Jeder Monat hat 28 - 31 Tage
		if len(month.Days) != month.DayCount {
			t.Errorf("Für den Monat %s stimmen Anzahl (%d) mit der Menge (%d) nicht überein", month.MonthName, month.DayCount, len(month.Days))
		}
	}
}

// TestISOWeekFormatting prüft die zweistellige Formatierung der Wochennummer.
func TestISOWeekFormatting(t *testing.T) {
	//t.Error("Check test failure")
	week := datatypes.WeekGroup{
		ISOYear: 2026,
		ISOWeek: 5,
	}

	formattedKW := fmt.Sprintf("%02d", week.ISOWeek)
	if formattedKW != "05" {
		t.Errorf("Erwartet '05', got '%s'", formattedKW)
	}
}

// TestLeapYearBoundary prüft den Schalttag am 29. Februar in Schaltjahren (Grenzbereich).
func TestLeapYearBoundary(t *testing.T) {
	//t.Error("Check test failure")
	// 2024 ist ein Schaltjahr
	days2024 := GenerateFullWeeksForYear(2024)

	foundFeb29 := false
	for _, day := range days2024 {
		if day.Date.Year() == 2024 && day.MonthNumber == 2 && day.DayOfMonth == 29 {
			foundFeb29 = true
			break
		}
	}

	if !foundFeb29 {
		t.Error("Grenzbereich-Fehler: 29. Februar 2024 (Schaltjahr) wurde nicht erzeugt.")
	}
}
