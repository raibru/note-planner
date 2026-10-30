package datatypes

import "time"

// DayInformation hält alle Informationen für einen einzelnen Tag.
type DayInformation struct {
	Date        time.Time // Das genaue Datum
	Year        int       // Das Jahr
	MonthNumber int       // 1 - 12
	MonthName   string    // z. B. "Januar"
	DayOfMonth  int       // 1 - 31
	WeekdayName string    // z. B. "Montag"
	ISOYear     int       // Das ISO-Jahr der Kalenderwoche
	ISOWeek     int       // Kalenderwoche nach ISO 8601 (1 - 53)
	IsHoliday   bool      // Ist der Tag ein Feiertag?
	HolidayName string    // Name des Feiertags (falls vorhanden)
}

// newDayInformation ist eine Hilfsfunktion zum Erstellen einer DayInformation.
func NewDayInformation(t time.Time, hname string) DayInformation {
	isoYear, isoWeek := t.ISOWeek()
	isHolyday := false
	if hname != "" {
		isHolyday = true
	}
	return DayInformation{
		Date:        t,
		Year:        int(t.Year()),
		MonthNumber: int(t.Month()),
		MonthName:   GermanMonths[t.Month()],
		DayOfMonth:  t.Day(),
		WeekdayName: GermanWeekdays[t.Weekday()],
		ISOYear:     isoYear,
		ISOWeek:     isoWeek,
		IsHoliday:   isHolyday,
		HolidayName: hname,
	}
}

// WeekGroup fasst alle Tage einer Kalenderwoche zusammen.
type WeekGroup struct {
	ISOYear int
	ISOWeek int
	Days    []DayInformation
}

// MonthGroup fasst alle Tage eines Kalendermontas zusammen.
type MonthGroup struct {
	Year      int
	Month     int
	MonthName string
	DayCount  int
	WeekCount int
	Days      []DayInformation
}

// Map zur Übersetzung der Wochentage auf Deutsch
var GermanWeekdays = map[time.Weekday]string{
	time.Sunday:    "Sonntag",
	time.Monday:    "Montag",
	time.Tuesday:   "Dienstag",
	time.Wednesday: "Mittwoch",
	time.Thursday:  "Donnerstag",
	time.Friday:    "Freitag",
	time.Saturday:  "Samstag",
}

// Map zur Übersetzung der Monate auf Deutsch
var GermanMonths = map[time.Month]string{
	time.January:   "Januar",
	time.February:  "Februar",
	time.March:     "März",
	time.April:     "April",
	time.May:       "Mai",
	time.June:      "Juni",
	time.July:      "Juli",
	time.August:    "August",
	time.September: "September",
	time.October:   "Oktober",
	time.November:  "November",
	time.December:  "Dezember",
}
