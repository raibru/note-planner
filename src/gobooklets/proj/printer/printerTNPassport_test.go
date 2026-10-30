package printer

import (
	"testing"

	"github.com/raibru/gobooklet/generator"
)

func TestGenerateYearDays(t *testing.T) {
	//t.Error("Check test failure")

	// Test 1: Normales Jahr (2025 -> 365 Tage)
	days2026 := generator.GenerateYearDays(2026)
	outDir := "/home/rbr/10_Projekte/gobooklets/proj/build/tests"

	cerr, err := PrintYearSection(2026, days2026, outDir)
	if err != nil {
		t.Errorf("Erstellen der Jahresübersicht Sektion war fehlerhaft mit (%v) %v", cerr, err)
	}
}

func TestPrintYearMonthSectionPage1(t *testing.T) {
	//t.Error("Check test failure")

	testYear := 2026
	outDir := "/home/rbr/10_Projekte/gobooklets/proj/build/tests"
	days2026 := generator.GenerateYearDays(testYear)
	months2026 := generator.GroupDaysByMonth(testYear, days2026)
	cerr, err := PrintYearMonthSectionPage1(testYear, months2026, 4, outDir)
	if err != nil {
		t.Errorf("Erstellen der Year-Month Sektion Pages war fehlerhaft mit (%v) %v", cerr, err)
	}
}

func TestPrintYearMonthSectionPage2(t *testing.T) {
	//t.Error("Check test failure")

	testYear := 2026
	outDir := "/home/rbr/10_Projekte/gobooklets/proj/build/tests"
	days2026 := generator.GenerateYearDays(testYear)
	months2026 := generator.GroupDaysByMonth(testYear, days2026)
	cerr, err := PrintYearMonthSectionPage2(testYear, months2026, 4, outDir)
	if err != nil {
		t.Errorf("Erstellen der Year-Month Sektion Pages war fehlerhaft mit (%v) %v", cerr, err)
	}
}

func TestPrintMonthlySectionPage1(t *testing.T) {
	//t.Error("Check test failure")

	// Test 1: Normales Jahr (2025 -> 365 Tage)
	testYear := 2026
	outDir := "/home/rbr/10_Projekte/gobooklets/proj/build/tests"
	days2026 := generator.GenerateYearDays(testYear)
	months2026 := generator.GroupDaysByMonth(testYear, days2026)
	cerr, err := PrintMonthSectionPage1(testYear, months2026, 2, outDir)
	if err != nil {
		t.Errorf("Erstellen der Monthly Sektion Page 1 war fehlerhaft mit (%v) %v", cerr, err)
	}
}

func TestPrintMonthlySectionPage2(t *testing.T) {
	//t.Error("Check test failure")

	// Test 1: Normales Jahr (2025 -> 365 Tage)
	testYear := 2026
	outDir := "/home/rbr/10_Projekte/gobooklets/proj/build/tests"
	days2026 := generator.GenerateYearDays(testYear)
	months2026 := generator.GroupDaysByMonth(testYear, days2026)
	cerr, err := PrintMonthSectionPage2(testYear, months2026, 2, outDir)
	if err != nil {
		t.Errorf("Erstellen der Monthly Sektion Page 2 war fehlerhaft mit (%v) %v", cerr, err)
	}
}
