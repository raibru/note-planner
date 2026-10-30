package printer

import (
	"testing"

	"github.com/raibru/gobooklet/generator"
)

func TestPrettyPrintByDay(t *testing.T) {
	//t.Error("Check test failure")
	testYear := 2027
	days := generator.GenerateYearDays(testYear)
	PrettyPrintByDate(days)
}

func TestPrettyPrintFullWeekByDay(t *testing.T) {
	//t.Error("Check test failure")
	testYear := 2027
	days := generator.GenerateFullWeeksForYear(testYear)
	PrettyPrintByDate(days)
}

func TestPrettyPrintGroupByMonat(t *testing.T) {
	//t.Error("Check test failure")
	testYear := 2027
	days := generator.GenerateYearDays(testYear)
	PrettyPrintGroupedByMonth(testYear, days)
}

func TestPrettyPrintGroupedByWeek(t *testing.T) {
	//t.Error("Check test failure")
	testYear := 2026
	days := generator.GenerateFullWeeksForYear(testYear)
	PrettyPrintGroupedByWeek(days)
}

func TestPrettyPrintHolidays(t *testing.T) {
	//t.Error("Check test failure")
	testYear := 2026
	days := generator.GenerateFullWeeksForYear(testYear)
	hdays := generator.GetHolidaysList(days)
	PrettyPrintHolidays(hdays)
}

func TestPrettyPrintGroupedByWeekWithHolidays(t *testing.T) {
	//t.Error("Check test failure")
	testYear := 2026
	days := generator.GenerateFullWeeksForYear(testYear)
	hdays := generator.GetHolidaysList(days)
	PrettyPrintGroupedByWeekWithHolidays(hdays)
}
