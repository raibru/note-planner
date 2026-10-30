package generator

import (
	"testing"
	"time"
)

// TestCalculateEasterSunday prüft bekannte Osterdaten inklusive der theoretischen Extremwerte.
func TestCalculateEasterSunday(t *testing.T) {
	//t.Error("Check test failure")

	tests := []struct {
		year          int
		expectedMonth time.Month
		expectedDay   int
	}{
		{2024, time.March, 31}, // Ostern im März
		{2025, time.April, 20}, // Normales Ostern
		{2026, time.April, 5},  // Ostern 2026
		{2038, time.April, 25}, // Spätestmögliches Ostern (25. April)
		{2285, time.March, 22}, // Frühestmögliches Ostern (22. März)
	}

	for _, tt := range tests {
		easter := CalculateEasterSunday(tt.year)
		if easter.Month() != tt.expectedMonth || easter.Day() != tt.expectedDay {
			t.Errorf("Jahr %d: Erwartet %02d.%02d, got %02d.%02d",
				tt.year, tt.expectedDay, tt.expectedMonth, easter.Day(), easter.Month())
		}
	}
}

// TestGetGermanHolidays static & dynamic checks
func TestGetGermanHolidays(t *testing.T) {
	//t.Error("Check test failure")

	year := 2026
	holidays := GetGermanHolidays(year)

	// 1. Statischen Feiertag prüfen
	found_10_03 := false
	expect_hd_10_03 := time.Date(year, time.October, 3, 0, 0, 0, 0, time.UTC)
	expect_hd_name_10_03 := "Tag der Deutschen Einheit"
	got_hd_name_10_03 := "unkown"
	for _, hd := range holidays {
		if hd.Date.Equal(expect_hd_10_03) && hd.Name == expect_hd_name_10_03 {
			found_10_03 = true
			expect_hd_name_10_03 = hd.Name
			break
		}
	}
	if !found_10_03 {
		t.Errorf("Erwartet 'Tag der Deutschen Einheit' am 03.10., got: %s", got_hd_name_10_03)
	}

	// 2. Dynamischen Feiertag (Karfreitag 2026 = 03. April) prüfen
	found_03_04 := false
	expect_hd_03_04 := time.Date(year, time.April, 3, 0, 0, 0, 0, time.UTC)
	expect_hd_name_03_04 := "Karfreitag"
	got_hd_name_03_04 := "unkown"
	for _, hd := range holidays {
		if hd.Date.Equal(expect_hd_03_04) && hd.Name == expect_hd_name_03_04 {
			found_03_04 = true
			got_hd_name_03_04 = hd.Name
			break
		}
	}
	if !found_03_04 {
		t.Errorf("Erwartet Karfreitag am 03.04.2026, got: %s", got_hd_name_03_04)
	}

	// 3. Dynamischen Feiertag (Christi Himmelfahrt 2026 = 14. Mai) prüfen
	found_14_05 := false
	expect_hd_14_05 := time.Date(year, time.May, 14, 0, 0, 0, 0, time.UTC)
	expect_hd_name_14_05 := "Christi Himmelfahrt"
	got_hd_name_14_05 := "unkown"
	for _, hd := range holidays {
		if hd.Date.Equal(expect_hd_14_05) && hd.Name == expect_hd_name_14_05 {
			found_14_05 = true
			expect_hd_name_14_05 = hd.Name
			break
		}
	}
	if !found_14_05 {
		t.Errorf("Erwartet Christi Himmelfahrt am 14.05.2026, got: %s", got_hd_name_14_05)
	}

}

// TestHolidaysListFilter prüft die Filterfunktion für die Feiertagsliste.
func TestHolidaysListFilter(t *testing.T) {
	//t.Error("Check test failure")

	testYear := 2026
	days := GenerateFullWeeksForYear(testYear)

	holidaysbyDay := GetHolidaysList(days)

	if len(holidaysbyDay) == 0 {
		t.Fatal("Feiertagsliste darf nicht leer sein.")
	}

	for _, h := range holidaysbyDay {
		if !h.IsHoliday {
			t.Errorf("Nicht-Feiertag in Feiertagsliste gefunden: %s", h.Date.Format("2006-01-02"))
		}
	}
}
