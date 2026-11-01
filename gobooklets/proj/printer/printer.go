package printer

import (
	"fmt"
	"strings"

	"github.com/raibru/gobooklet/datatypes"
	"github.com/raibru/gobooklet/generator"
)

// PrettyPrint gibt die Tage flach in Tabellenform aus.
func PrettyPrintByDate(days []datatypes.DayInformation) {
	if len(days) == 0 {
		fmt.Println("Keine Daten zum Anzeigen vorhanden.")
		return
	}

	header := fmt.Sprintf("| %-10s | %-10s | %-12s | %-8s | %-10s | %-12s |", "Datum", "Monat-Nr.", "Monat", "Tag-Nr.", "Wochentag", "ISO-KW")
	separator := strings.Repeat("-", len(header))

	fmt.Println(separator)
	fmt.Println(header)
	fmt.Println(separator)

	for _, day := range days {
		kwString := fmt.Sprintf("KW %02d (%d)", day.ISOWeek, day.ISOYear)
		dateStr := day.Date.Format("2006-01-02")
		fmt.Printf("| %-10s | %-10d | %-12s | %-8d | %-10s | %-12s |\n",
			dateStr,
			day.MonthNumber,
			day.MonthName,
			day.DayOfMonth,
			day.WeekdayName,
			kwString,
		)
	}

	fmt.Println(separator)
}

// PrettyPrintGroupedByWeek gibt die Tage gruppiert nach Kalenderwochen aus.
func PrettyPrintGroupedByWeek(days []datatypes.DayInformation) {
	weeks := generator.GroupDaysByWeek(days)

	for _, week := range weeks {
		// Zweistellige Wochennummer (z. B. "Woche 01 (2026)")
		fmt.Printf("\n=== Woche %02d (%d) ===\n", week.ISOWeek, week.ISOYear)

		header := fmt.Sprintf("| %-10s | %-10s | %-12s | %-8s | %-10s |", "Datum", "Monat-Nr.", "Monat", "Tag-Nr.", "Wochentag")
		separator := strings.Repeat("-", len(header))

		fmt.Println(separator)
		fmt.Println(header)
		fmt.Println(separator)

		for _, day := range week.Days {
			dateStr := day.Date.Format("2006-01-02")
			fmt.Printf("| %-10s | %-10d | %-12s | %-8d | %-10s |\n",
				dateStr,
				day.MonthNumber,
				day.MonthName,
				day.DayOfMonth,
				day.WeekdayName,
			)
		}
		fmt.Println(separator)
	}
}

// PrettyPrintGroupedByMonth gibt die Tage gruppiert nach Monaten aus.
func PrettyPrintGroupedByMonth(year int, days []datatypes.DayInformation) {
	months := generator.GroupDaysByMonth(year, days)

	for _, month := range months {
		fmt.Printf("\n=== %s (%d) ===\n", month.MonthName, year)

		header := fmt.Sprintf("| %-2s | %-2s | %-2s | %-2s | %-2s | %-2s | %-2s | %-2s |", "KW", "Mo", "Di", "Mi", "Do", "Fr", "Sa", "So")
		separator := strings.Repeat("-", len(header))

		fmt.Println(separator)
		fmt.Println(header)
		fmt.Println(separator)

		montag := ""
		dienstag := ""
		mittwoch := ""
		donnerstag := ""
		freitag := ""
		samstag := ""
		sonntag := ""

		for _, day := range month.Days {
			switch day.WeekdayName {
			case "Montag":
				montag = day.Date.Format("02")
			case "Dienstag":
				dienstag = day.Date.Format("02")
			case "Mittwoch":
				mittwoch = day.Date.Format("02")
			case "Donnerstag":
				donnerstag = day.Date.Format("02")
			case "Freitag":
				freitag = day.Date.Format("02")
			case "Samstag":
				samstag = day.Date.Format("02")
			case "Sonntag":
				sonntag = day.Date.Format("02")
			}

			if day.WeekdayName == "Sonntag" || day.DayOfMonth == month.DayCount {
				kw := day.ISOWeek
				fmt.Printf("| %-02d | %-2s | %-2s | %-2s | %-2s | %-2s | %-2s | %-2s |\n", kw, montag, dienstag, mittwoch, donnerstag, freitag, samstag, sonntag)
				montag = ""
				dienstag = ""
				mittwoch = ""
				donnerstag = ""
				freitag = ""
				samstag = ""
				sonntag = ""
			}

		}

		fmt.Println(separator)

	}
}

func PrettyPrintGroupedByWeekWithHolidays(days []datatypes.DayInformation) {
	weeks := generator.GroupDaysByWeek(days)
	for _, week := range weeks {
		fmt.Printf("\n=== Woche %02d (%d) ===\n", week.ISOWeek, week.ISOYear)

		header := fmt.Sprintf("| %-10s | %-10s | %-12s | %-8s | %-10s | %-26s |", "Datum", "Monat-Nr.", "Monat", "Tag-Nr.", "Wochentag", "Feiertag")
		separator := strings.Repeat("-", len(header))

		fmt.Println(separator)
		fmt.Println(header)
		fmt.Println(separator)

		for _, day := range week.Days {
			dateStr := day.Date.Format("2006-01-02")
			holidayStr := "-"
			if day.IsHoliday {
				holidayStr = day.HolidayName
			}

			fmt.Printf("| %-10s | %-10d | %-12s | %-8d | %-10s | %-26s |\n",
				dateStr,
				day.MonthNumber,
				day.MonthName,
				day.DayOfMonth,
				day.WeekdayName,
				holidayStr,
			)
			fmt.Println(separator)
		}
	}
}

// PrettyPrintHolidays gibt die gefilterte Liste der Feiertage aus.
func PrettyPrintHolidays(holidays []datatypes.DayInformation) {
	fmt.Println("\n=== Übersichtsliste der Feiertage ===")
	header := fmt.Sprintf("| %-10s | %-10s | %-26s |", "Datum", "Wochentag", "Feiertag")
	separator := strings.Repeat("-", len(header))

	fmt.Println(separator)
	fmt.Println(header)
	fmt.Println(separator)

	for _, day := range holidays {
		fmt.Printf("| %-10s | %-10s | %-26s |\n",
			day.Date.Format("2006-01-02"),
			day.WeekdayName,
			day.HolidayName,
		)
	}
	fmt.Println(separator)
}
