package generator

import (
	"time"

	"github.com/raibru/gobooklet/datatypes"
)

type Holyday struct {
	Date time.Time
	Name string
}

// CalculateEasterSunday berechnet den Ostersonntag für ein Jahr nach dem Gaußschen Osteralgorithmus.
func CalculateEasterSunday(year int) time.Time {
	a := year % 19
	b := year / 100
	c := year % 100
	d := b / 4
	e := b % 4
	f := (b + 8) / 25
	g := (b - f + 1) / 3
	h := (19*a + b - d - g + 15) % 30
	i := c / 4
	k := c % 4
	l := (32 + 2*e + 2*i - h - k) % 7
	m := (a + 11*h + 22*l) / 451
	month := (h + l - 7*m + 114) / 31
	day := ((h + l - 7*m + 114) % 31) + 1

	return time.Date(year, time.Month(month), day, 0, 0, 0, 0, time.UTC)
}

// GetGermanHolidays ermittelt alle bundeseinheitlichen statischen und dynamischen Feiertage.
func GetGermanHolidays(year int) []Holyday {
	var hds []Holyday

	hds = append(
		hds,
		Holyday{
			Date: time.Date(year, time.January, 1, 0, 0, 0, 0, time.UTC),
			Name: "Neujahr",
		})
	hds = append(
		hds,
		Holyday{
			Date: time.Date(year, time.May, 1, 0, 0, 0, 0, time.UTC),
			Name: "Tag der Arbeit",
		})
	hds = append(
		hds,
		Holyday{
			Date: time.Date(year, time.October, 3, 0, 0, 0, 0, time.UTC),
			Name: "Tag der Deutschen Einheit",
		})
	hds = append(
		hds,
		Holyday{
			Date: time.Date(year, time.October, 31, 0, 0, 0, 0, time.UTC),
			Name: "Reformationstag",
		})
	hds = append(
		hds,
		Holyday{
			Date: time.Date(year, time.December, 25, 0, 0, 0, 0, time.UTC),
			Name: "1. Weihnachtstag",
		})
	hds = append(
		hds,
		Holyday{
			Date: time.Date(year, time.December, 26, 0, 0, 0, 0, time.UTC),
			Name: "2. Weihnachtstag",
		})

	// Dynamische Feiertage basierend auf Ostern
	easterSunday := CalculateEasterSunday(year)

	hds = append(
		hds,
		Holyday{
			Date: easterSunday.AddDate(0, 0, -2),
			Name: "Karfreitag",
		})
	hds = append(
		hds,
		Holyday{
			Date: easterSunday,
			Name: "Ostersonntag",
		})
	hds = append(
		hds,
		Holyday{
			Date: easterSunday.AddDate(0, 0, 1),
			Name: "Ostermontag",
		})
	hds = append(
		hds,
		Holyday{
			Date: easterSunday.AddDate(0, 0, 39),
			Name: "Christi Himmelfahrt",
		})
	hds = append(
		hds,
		Holyday{
			Date: easterSunday.AddDate(0, 0, 49),
			Name: "Pfingstsonntag",
		})
	hds = append(
		hds,
		Holyday{
			Date: easterSunday.AddDate(0, 0, 50),
			Name: "Pfingstmontag",
		})

	return hds
}

// SetDaysByHolydays ergänzt in der Day Liste die Tage, die Feiertage sind
func SetDaysByHolydays(days []datatypes.DayInformation, holydays []Holyday) {
	for _, day := range days {
		for _, hday := range holydays {
			if holydays[0].Date.Equal(day.Date) {
				day.IsHoliday = true
				day.HolidayName = hday.Name
			}
		}
	}
}

// GetHolidaysList gibt eine Liste aller gefundenen Feiertage innerhalb des Zeitraums zurück.
func GetHolidaysList(days []datatypes.DayInformation) []datatypes.DayInformation {
	var holidayList []datatypes.DayInformation
	for _, day := range days {
		if day.IsHoliday {
			holidayList = append(holidayList, day)
		}
	}
	return holidayList
}

func FindHolyday(date time.Time, hdays []Holyday) (bool, Holyday) {
	for _, hday := range hdays {
		if hday.Date.Equal(date) {
			return true, hday
		}
	}
	return false, Holyday{}
}
