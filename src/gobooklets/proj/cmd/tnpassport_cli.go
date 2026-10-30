/*
Copyright © 2021 NAME HERE <EMAIL ADDRESS>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package cmd

import (
	"errors"
	"fmt"
	"os"

	"github.com/raibru/gobooklet/generator"
	"github.com/raibru/gobooklet/io"
	"github.com/raibru/gobooklet/printer"
	"github.com/spf13/cobra"
)

var (
	tnpp_year  bool
	tnpp_month bool
	tnpp_week  bool
)

// edenCmd represents the eden dump command
var tnPassportCmd = &cobra.Command{
	Use:   "tn-passport",
	Short: "Traveler's Note Passport booklet handling",
	Long: `
Print Traveler's Note Passport sized booklets.

Execute for further information

gobooklet tn_passport --examples

`,
	Run: func(cmd *cobra.Command, args []string) {
		if cerr, err := handleTnPassportParams(cmd, args); err != nil {
			cmd.Help()
			fmt.Printf("*** Error: parsing command has error: \n%s\n", err)
			os.Exit(cerr)
		}
	},
}

func init() {
	rootCmd.AddCommand(tnPassportCmd)

	tnPassportCmd.PersistentFlags().BoolVarP(&tnpp_year, "year-section", "", false, "create a year overview section (default: false)")
	tnPassportCmd.PersistentFlags().BoolVarP(&tnpp_month, "month-section", "", false, "create a month overview of year section (default: false)")
	tnPassportCmd.PersistentFlags().BoolVarP(&tnpp_week, "week-section", "", false, "create a week overview of year section (default: false)")

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// pduCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// pduCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")
}

func handleTnPassportParams(cmd *cobra.Command, args []string) (errcode int, err error) {
	if year == 0 {
		fmt.Println("... check mandatory parameter year")
		err = errors.New("must have mandentory parameter year")
		return 2, err
	} else if year > 0 {
		fmt.Println("... generate year with date items")
		days := generator.GenerateYearDays(year)
		fmt.Println("... generate year with date per week items")
		daysByWeek := generator.GenerateFullWeeksForYear(year)
		if dumpDays {
			fmt.Println("... use pretty print by date")
			printer.PrettyPrintByDate(days)
		}
		if dumpDaysByWeek {
			fmt.Println("... use pretty print dates grouped by week")
			printer.PrettyPrintGroupedByWeek(daysByWeek)
		}
		if tnpp_year {
			outdir := fmt.Sprintf("%s/%d", outputDir, year)
			if !io.ExistsOutputDir(outdir) {
				if err := io.CreateOutputDir(outdir); err != nil {
					return 3, err
				}
			}

			cerr, err := printer.PrintYearOverviewSection(year, days, outdir)
			if err != nil {
				return cerr, err
			}

			fmt.Println("... generate month per year overview page 1")
			days := generator.GenerateYearDays(year)
			months := generator.GroupDaysByMonth(year, days)
			cerr, err = printer.PrintYearMonthSectionPage1(year, months, 4, outdir)
			if err != nil {
				return cerr, err
			}

			fmt.Println("... finish month per year overview page 1 in year")
			fmt.Println("... generate month per year overview page 2 in year")
			cerr, err = printer.PrintYearMonthSectionPage2(year, months, 4, outdir)
			if err != nil {
				return cerr, err
			}

			fmt.Println("... finish month per year overview page 2 in year")
		}
		if tnpp_month {
			outdir := fmt.Sprintf("%s/%d", outputDir, year)
			if !io.ExistsOutputDir(outdir) {
				if err := io.CreateOutputDir(outdir); err != nil {
					return 3, err
				}
			}

			fmt.Println("... generate month overview page 1 in year")
			months := generator.GroupDaysByMonth(year, days)
			cerr, err := printer.PrintMonthSectionPage1(year, months, 2, outdir)
			if err != nil {
				return cerr, err
			}

			fmt.Println("... finish month overview page 1 in year")
			fmt.Println("... generate month overview page 2 in year")
			cerr, err = printer.PrintMonthSectionPage2(year, months, 2, outdir)
			if err != nil {
				return cerr, err
			}

			fmt.Println("... finish month overview page 2 in year")
		}
	}
	fmt.Println("... done TN-Passport")
	return 0, nil
}
