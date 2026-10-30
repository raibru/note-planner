package generator

// data structure isoweek, date_mon - date_sun, weeklead, month

import (
	"time"

	"github.com/raibru/gobooklet/datatypes"
)

// GenerateYearDays erzeugt eine Liste aller Tage eines vorgegebenen Jahres.
func GenerateYearDays(year int) []datatypes.DayInformation {
	var days []datatypes.DayInformation

	hdays := GetGermanHolidays(year)

	// Start am 1. Januar des angegebenen Jahres
	currentDate := time.Date(year, time.January, 1, 0, 0, 0, 0, time.UTC)

	// Schleife läuft, solange wir im selben Jahr sind
	for currentDate.Year() == year {
		hname := ""
		found, holyday := FindHolyday(currentDate, hdays)
		if found {
			hname = holyday.Name
		}

		dayInfo := datatypes.NewDayInformation(currentDate, hname)
		days = append(days, dayInfo)
		// Einen Tag weitergehen
		currentDate = currentDate.AddDate(0, 0, 1)
	}

	return days
}

// GenerateFullWeeksForYear erzeugt alle Tage für das angegebene Jahr.
// Wochen beginnen immer am Montag und enden am Sonntag.
// Die erste und letzte Woche werden mit Tagen aus dem Vor- bzw. Folgejahr aufgefüllt.
func GenerateFullWeeksForYear(year int) []datatypes.DayInformation {
	jan1 := time.Date(year, time.January, 1, 0, 0, 0, 0, time.UTC)

	// Startdatum ermitteln: Falls der 1. Jan kein Montag ist, gehen wir zurück bis zum Montag
	start := jan1
	for start.Weekday() != time.Monday {
		start = start.AddDate(0, 0, -1)
	}

	dec31 := time.Date(year, time.December, 31, 0, 0, 0, 0, time.UTC)

	// Enddatum ermitteln: Falls der 31. Dez kein Sonntag ist, gehen wir vorwärts bis zum Sonntag
	end := dec31
	for end.Weekday() != time.Sunday {
		end = end.AddDate(0, 0, 1)
	}

	var days []datatypes.DayInformation
	hdays := GetGermanHolidays(year)
	for curr := start; !curr.After(end); curr = curr.AddDate(0, 0, 1) {
		hname := ""
		found, holyday := FindHolyday(curr, hdays)
		if found {
			hname = holyday.Name
		}
		days = append(days, datatypes.NewDayInformation(curr, hname))
	}

	return days
}

// GroupDaysByWeek gruppiert eine Liste von Tagen in Wochen.
func GroupDaysByWeek(days []datatypes.DayInformation) []datatypes.WeekGroup {
	var weeks []datatypes.WeekGroup
	var currentWeek *datatypes.WeekGroup

	for _, day := range days {
		if currentWeek == nil || currentWeek.ISOWeek != day.ISOWeek || currentWeek.ISOYear != day.ISOYear {
			if currentWeek != nil {
				weeks = append(weeks, *currentWeek)
			}
			currentWeek = &datatypes.WeekGroup{
				ISOYear: day.ISOYear,
				ISOWeek: day.ISOWeek,
				Days:    make([]datatypes.DayInformation, 0, 7),
			}
		}
		currentWeek.Days = append(currentWeek.Days, day)
	}

	if currentWeek != nil {
		weeks = append(weeks, *currentWeek)
	}

	return weeks
}

// GroupDaysByMonth gruppiert eine Liste von Tagen in Monate.
func GroupDaysByMonth(year int, days []datatypes.DayInformation) []datatypes.MonthGroup {
	var months []datatypes.MonthGroup
	var currentMonth *datatypes.MonthGroup
	var currentISOWeek int
	var dayCounter int
	var weekCounter int

	for _, day := range days {
		if day.Date.Year() != year {
			continue
		}

		if currentMonth == nil || currentMonth.Month != day.MonthNumber || currentMonth.Year != day.Year {
			if currentMonth != nil {
				currentMonth.DayCount = dayCounter
				currentMonth.WeekCount = weekCounter
				months = append(months, *currentMonth)
				dayCounter = 0
				weekCounter = 0
			}
			currentMonth = &datatypes.MonthGroup{
				Year:      day.Year,
				Month:     day.MonthNumber,
				MonthName: day.MonthName,
				Days:      make([]datatypes.DayInformation, 0, 31),
			}
		}

		currentMonth.Days = append(currentMonth.Days, day)
		dayCounter += 1

		if currentISOWeek != day.ISOWeek {
			currentISOWeek = day.ISOWeek
			weekCounter += 1
		}

	}

	if currentMonth != nil {
		currentMonth.DayCount = dayCounter
		currentMonth.WeekCount = weekCounter
		months = append(months, *currentMonth)
		dayCounter = 0
		weekCounter = 0
	}

	return months
}
