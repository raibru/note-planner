package printer

import (
	"fmt"

	"github.com/fogleman/gg"
	"github.com/raibru/gobooklet/datatypes"
)

type outDay struct {
	x float64
	y float64
	v string
}

func PrintYearOverviewSection(year int, days []datatypes.DayInformation, outDir string) (cerr int, err error) {
	in := "/home/rbr/10_Projekte/gobooklets/proj/assets/tn-passport/TNPassport-Planner-Yearly.png"
	img, err := gg.LoadImage(in)
	if err != nil {
		return 3, err
	}
	bounds := img.Bounds()
	dc := gg.NewContext(bounds.Dx(), bounds.Dy())
	dc.DrawImage(img, 0, 0)
	dc.SetRGB(0, 0, 0)

	// Load a TTF font file and set size
	// if err := dc.LoadFontFace("arial.ttf", 48); err != nil {

	//	font, err := truetype.Parse(goregular.TTF)
	//	if err != nil {
	//		log.Fatal(err)
	//	}
	//	face := truetype.NewFace(font, &truetype.Options{Size: 24})
	//	dc.SetFontFace(face)

	if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 24); err != nil {
		return 3, err
	}

	dc.DrawStringAnchored(fmt.Sprintf("%d", year), 40, 20, 0.5, 0.5)

	out := fmt.Sprintf("%s/00-Year-Overview-%d.png", outDir, year)
	if err := dc.SavePNG(out); err != nil {
		return 3, err
	}

	return 0, nil
}

func PrintYearMonthSectionPages(year int, months []datatypes.MonthGroup, ordNr int, outDir string) (cerr int, err error) {

	yearPosX := 414.0 //25.0
	yearPosY := 10.0
	monthPosX := 459.0 //70.0
	monthPosY := 32.0
	dayPosX := 401.0 //12.0
	dayPosY := 48.0

	in := "/home/rbr/10_Projekte/gobooklets/proj/assets/tn-passport/TNPassport-Yearly-Wide-6.png"
	img, err := gg.LoadImage(in)
	if err != nil {
		return 3, err
	}

	bounds := img.Bounds()
	page := 1
	var dc *gg.Context

	for _, month := range months {
		if dc == nil {
			dc = gg.NewContext(bounds.Dx(), bounds.Dy())
			dc.DrawImage(img, 0, 0)
			dc.SetRGB(0, 0, 0)
		}

		if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 12); err != nil {
			return 3, err
		}

		fmt.Printf("... ... print year %04d\n", year)
		dc.DrawStringAnchored(fmt.Sprintf("%04d", year), yearPosX, yearPosY, 0.5, 0.5)
		fmt.Printf("... ... print month %s for %d\n", month.MonthName, year)
		dc.DrawStringAnchored(fmt.Sprintf("%s", month.MonthName), monthPosX, monthPosY, 0.5, 0.5)
		monthPosX += 127

		if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 9); err != nil {
			return 3, err
		}
		for _, day := range month.Days {
			fmt.Printf("... ... ... print day %02d - %s - %s\n", day.Date.Day(), day.WeekdayName[0:2], day.HolidayName)
			dc.DrawStringAnchored(fmt.Sprintf("%02d %s  %s", day.Date.Day(), day.WeekdayName[0:2], day.HolidayName), dayPosX, dayPosY, 0.0, 0.5)
			dayPosY += 15
		}
		dayPosX += 128
		dayPosY = 48

		if month.MonthName == "Juni" || month.MonthName == "Dezember" {
			fmt.Printf("... ... print year page %d\n", page)

			out := fmt.Sprintf("%s/%02d-%04d-%02d-TNPassport-Planner-Yearly.png", outDir, ordNr, year, page)
			if err := dc.SavePNG(out); err != nil {
				return 3, err
			}

			page += 1
			monthPosX = 459.0 //70.0
			monthPosY = 32.0
			dayPosX = 401.0 //12.0
			dayPosY = 48.0
			dc = nil
		}

	}

	return 0, nil
}

func PrintYearMonthSectionPage1(year int, months []datatypes.MonthGroup, ordNr int, outDir string) (cerr int, err error) {

	yearPosX := 414.0 //25.0
	yearPosY := 10.0
	monthPosX := 459.0 //70.0
	monthPosY := 32.0
	dayPosX := 401.0 //12.0
	dayPosY := 48.0

	in := "/home/rbr/10_Projekte/gobooklets/proj/assets/tn-passport/TNPassport-Yearly-Wide-1-1.png"
	img, err := gg.LoadImage(in)
	if err != nil {
		return 3, err
	}

	bounds := img.Bounds()
	dc := gg.NewContext(bounds.Dx(), bounds.Dy())
	dc.DrawImage(img, 0, 0)
	dc.SetRGB(0, 0, 0)

	for _, month := range months[:6] {

		if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 12); err != nil {
			return 3, err
		}

		fmt.Printf("... ... print year %04d\n", year)
		dc.DrawStringAnchored(fmt.Sprintf("%04d", year), yearPosX, yearPosY, 0.5, 0.5)
		fmt.Printf("... ... print month %s for %d\n", month.MonthName, year)
		dc.DrawStringAnchored(fmt.Sprintf("%s", month.MonthName), monthPosX, monthPosY, 0.5, 0.5)
		monthPosX += 127

		if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 9); err != nil {
			return 3, err
		}

		for _, day := range month.Days {
			fmt.Printf("... ... ... print day %02d - %s - %s\n", day.Date.Day(), day.WeekdayName[0:2], day.HolidayName)
			dc.DrawStringAnchored(fmt.Sprintf("%02d %s  %s", day.Date.Day(), day.WeekdayName[0:2], day.HolidayName), dayPosX, dayPosY, 0.0, 0.5)
			dayPosY += 15
		}

		dayPosX += 128
		dayPosY = 48

	}

	fmt.Printf("... ... print year page %d\n", 1)

	out := fmt.Sprintf("%s/%02d-%04d-%02d-TNPassport-Planner-Yearly.png", outDir, ordNr, year, 1)
	//out := fmt.Sprintf("/home/rbr/10_Projekte/gobooklets/proj/build/tn-passport/%02d-%04d-%02d-TNPassport-Planner-Yearly.png", ordNr, year, 1)
	if err := dc.SavePNG(out); err != nil {
		return 3, err
	}

	return 0, nil
}

func PrintYearMonthSectionPage2(year int, months []datatypes.MonthGroup, ordNr int, outDir string) (cerr int, err error) {

	yearPosX := 25.0
	yearPosY := 10.0
	monthPosX := 70.0
	monthPosY := 32.0
	dayPosX := 12.0
	dayPosY := 48.0

	in := "/home/rbr/10_Projekte/gobooklets/proj/assets/tn-passport/TNPassport-Yearly-Wide-1-2.png"
	img, err := gg.LoadImage(in)
	if err != nil {
		return 3, err
	}

	bounds := img.Bounds()
	dc := gg.NewContext(bounds.Dx(), bounds.Dy())
	dc.DrawImage(img, 0, 0)
	dc.SetRGB(0, 0, 0)

	for _, month := range months[6:] {

		if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 12); err != nil {
			return 3, err
		}

		fmt.Printf("... ... print year %04d\n", year)
		dc.DrawStringAnchored(fmt.Sprintf("%04d", year), yearPosX, yearPosY, 0.5, 0.5)
		fmt.Printf("... ... print month %s for %d\n", month.MonthName, year)
		dc.DrawStringAnchored(fmt.Sprintf("%s", month.MonthName), monthPosX, monthPosY, 0.5, 0.5)
		monthPosX += 127

		if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 9); err != nil {
			return 3, err
		}

		for _, day := range month.Days {
			fmt.Printf("... ... ... print day %02d - %s - %s\n", day.Date.Day(), day.WeekdayName[0:2], day.HolidayName)
			dc.DrawStringAnchored(fmt.Sprintf("%02d %s  %s", day.Date.Day(), day.WeekdayName[0:2], day.HolidayName), dayPosX, dayPosY, 0.0, 0.5)
			dayPosY += 15
		}

		dayPosX += 128
		dayPosY = 48

	}

	fmt.Printf("... ... print year page %d\n", 2)

	out := fmt.Sprintf("%s/%02d-%04d-%02d-TNPassport-Planner-Yearly.png", outDir, ordNr, year, 2)
	//out := fmt.Sprintf("/home/rbr/10_Projekte/gobooklets/proj/build/tn-passport/%02d-%04d-%02d-TNPassport-Planner-Yearly.png", ordNr, year, 2)
	if err := dc.SavePNG(out); err != nil {
		return 3, err
	}

	return 0, nil
}

func PrintMonthSectionPage1(year int, months []datatypes.MonthGroup, ordNr int, outDir string) (cerr int, err error) {

	in := "/home/rbr/10_Projekte/gobooklets/proj/assets/tn-passport/TNPassport-Planner-Monthly-6-1.png"
	img, err := gg.LoadImage(in)
	if err != nil {
		return 3, err
	}

	bounds := img.Bounds()

	// Load a TTF font file and set size
	// if err := dc.LoadFontFace("arial.ttf", 48); err != nil {

	//	font, err := truetype.Parse(goregular.TTF)
	//	if err != nil {
	//		log.Fatal(err)
	//	}
	//	face := truetype.NewFace(font, &truetype.Options{Size: 24})
	//	dc.SetFontFace(face)

	for _, month := range months {
		fmt.Printf("... ... generate page 1 for %s\n", month.MonthName)

		out_mo := outDay{x: 55.0, y: 70.0}
		out_di := outDay{x: 123.0, y: 70.0}
		out_mi := outDay{x: 191.0, y: 70.0}
		out_do := outDay{x: 259.0, y: 70.0}
		out_fr := outDay{x: 327.0, y: 70.0}

		outh_mo := outDay{x: 46.0, y: 123.0}
		outh_di := outDay{x: 114.0, y: 123.0}
		outh_mi := outDay{x: 182.0, y: 123.0}
		outh_do := outDay{x: 250.0, y: 123.0}
		outh_fr := outDay{x: 319.0, y: 123.0}

		dc := gg.NewContext(bounds.Dx(), bounds.Dy())
		dc.DrawImage(img, 0, 0)
		dc.SetRGB(0, 0, 0)

		if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 24); err != nil {
			return 3, err
		}
		dc.DrawStringAnchored(fmt.Sprintf("%s", month.MonthName), 60, 20, 0.5, 0.5)

		for _, day := range month.Days {
			switch day.WeekdayName {
			case "Montag":
				out_mo.v = day.Date.Format("02")
				outh_mo.v = day.HolidayName
			case "Dienstag":
				out_di.v = day.Date.Format("02")
				outh_di.v = day.HolidayName
			case "Mittwoch":
				out_mi.v = day.Date.Format("02")
				outh_mi.v = day.HolidayName
			case "Donnerstag":
				out_do.v = day.Date.Format("02")
				outh_do.v = day.HolidayName
			case "Freitag":
				out_fr.v = day.Date.Format("02")
				outh_fr.v = day.HolidayName
			case "Samstag":
				continue
			case "Sonntag":
				if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 14); err != nil {
					return 3, err
				}

				dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_mo.v), out_mo.x, out_mo.y, 0.5, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_di.v), out_di.x, out_di.y, 0.5, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_mi.v), out_mi.x, out_mi.y, 0.5, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_do.v), out_do.x, out_do.y, 0.5, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_fr.v), out_fr.x, out_fr.y, 0.5, 0.5)

				if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 8); err != nil {
					return 3, err
				}

				dc.DrawStringAnchored(fmt.Sprintf("%s", outh_mo.v), outh_mo.x, outh_mo.y, 0.0, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%s", outh_di.v), outh_di.x, outh_di.y, 0.0, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%s", outh_mi.v), outh_mi.x, outh_mi.y, 0.0, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%s", outh_do.v), outh_do.x, outh_do.y, 0.0, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%s", outh_fr.v), outh_fr.x, outh_fr.y, 0.0, 0.5)

				out_mo.v = ""
				out_di.v = ""
				out_mi.v = ""
				out_do.v = ""
				out_fr.v = ""

				outh_mo.v = ""
				outh_di.v = ""
				outh_mi.v = ""
				outh_do.v = ""
				outh_fr.v = ""

				out_mo.y += 74.0
				out_di.y += 74.0
				out_mi.y += 74.0
				out_do.y += 74.0
				out_fr.y += 74.0

				outh_mo.y += 74.0
				outh_di.y += 74.0
				outh_mi.y += 74.0
				outh_do.y += 74.0
				outh_fr.y += 74.0
			}

			if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 14); err != nil {
				return 3, err
			}

			dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_mo.v), out_mo.x, out_mo.y, 0.5, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_di.v), out_di.x, out_di.y, 0.5, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_mi.v), out_mi.x, out_mi.y, 0.5, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_do.v), out_do.x, out_do.y, 0.5, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_fr.v), out_fr.x, out_fr.y, 0.5, 0.5)

			if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 8); err != nil {
				return 3, err
			}

			dc.DrawStringAnchored(fmt.Sprintf("%s", outh_mo.v), outh_mo.x, outh_mo.y, 0.0, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%s", outh_di.v), outh_di.x, outh_di.y, 0.0, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%s", outh_mi.v), outh_mi.x, outh_mi.y, 0.0, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%s", outh_do.v), outh_do.x, outh_do.y, 0.0, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%s", outh_fr.v), outh_fr.x, outh_fr.y, 0.0, 0.5)
		}

		out := fmt.Sprintf("%s/%02d-%02d-1-TNPassport-Planner-Monthly.png", outDir, ordNr, month.Month)
		//out := fmt.Sprintf("/home/rbr/10_Projekte/gobooklets/proj/build/tn-passport/%02d-%02d-1-TNPassport-Planner-Monthly.png", ordNr, month.Month)
		if err := dc.SavePNG(out); err != nil {
			return 3, err
		}
	}

	return 0, nil
}

func PrintMonthSectionPage2(year int, months []datatypes.MonthGroup, ordNr int, outDir string) (cerr int, err error) {
	in := "/home/rbr/10_Projekte/gobooklets/proj/assets/tn-passport/TNPassport-Planner-Monthly-6-2.png"
	img, err := gg.LoadImage(in)
	if err != nil {
		return 3, err
	}
	bounds := img.Bounds()

	// Load a TTF font file and set size
	// if err := dc.LoadFontFace("arial.ttf", 48); err != nil {

	//	font, err := truetype.Parse(goregular.TTF)
	//	if err != nil {
	//		log.Fatal(err)
	//	}
	//	face := truetype.NewFace(font, &truetype.Options{Size: 24})
	//	dc.SetFontFace(face)

	for _, month := range months {
		fmt.Printf("... ... generate page 2 for %s\n", month.MonthName)

		out_sa := outDay{x: 30.0, y: 70.0}
		out_so := outDay{x: 98.0, y: 70.0}

		outh_sa := outDay{x: 21.0, y: 123.0}
		outh_so := outDay{x: 89.0, y: 123.0}

		dc := gg.NewContext(bounds.Dx(), bounds.Dy())
		dc.DrawImage(img, 0, 0)
		dc.SetRGB(0, 0, 0)

		if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 24); err != nil {
			return 3, err
		}

		dc.DrawStringAnchored(fmt.Sprintf("%d", year), 350, 20, 0.5, 0.5)

		for _, day := range month.Days {
			switch day.WeekdayName {
			case "Montag":
				continue
			case "Dienstag":
				continue
			case "Mittwoch":
				continue
			case "Donnerstag":
				continue
			case "Freitag":
				continue
			case "Samstag":
				out_sa.v = day.Date.Format("02")
				outh_sa.v = day.HolidayName
			case "Sonntag":
				out_so.v = day.Date.Format("02")
				outh_so.v = day.HolidayName

				if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 14); err != nil {
					return 3, err
				}

				dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_sa.v), out_sa.x, out_sa.y, 0.5, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_so.v), out_so.x, out_so.y, 0.5, 0.5)

				if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 8); err != nil {
					return 3, err
				}

				dc.DrawStringAnchored(fmt.Sprintf("%s", outh_sa.v), outh_sa.x, outh_sa.y, 0.0, 0.5)
				dc.DrawStringAnchored(fmt.Sprintf("%s", outh_so.v), outh_so.x, outh_so.y, 0.0, 0.5)

				out_sa.v = ""
				out_so.v = ""

				outh_sa.v = ""
				outh_so.v = ""

				out_sa.y += 74.0
				out_so.y += 74.0

				outh_sa.y += 74.0
				outh_so.y += 74.0
			}

			if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 14); err != nil {
				return 3, err
			}

			dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_sa.v), out_sa.x, out_sa.y, 0.5, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%-02s", out_so.v), out_so.x, out_so.y, 0.5, 0.5)

			if err := dc.LoadFontFace("/usr/share/fonts/truetype/gentium/GentiumAlt-R.ttf", 8); err != nil {
				return 3, err
			}

			dc.DrawStringAnchored(fmt.Sprintf("%s", outh_sa.v), outh_sa.x, outh_sa.y, 0.0, 0.5)
			dc.DrawStringAnchored(fmt.Sprintf("%s", outh_so.v), outh_so.x, outh_so.y, 0.0, 0.5)
		}

		out := fmt.Sprintf("%s/%02d-%02d-2-TNPassport-Planner-Monthly.png", outDir, ordNr, month.Month)
		//out := fmt.Sprintf("/home/rbr/10_Projekte/gobooklets/proj/build/tn-passport/%02d-%02d-2-TNPassport-Planner-Monthly.png", ordNr, month.Month)
		if err := dc.SavePNG(out); err != nil {
			return 3, err
		}
	}

	return 0, nil
}
