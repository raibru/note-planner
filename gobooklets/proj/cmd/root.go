package cmd

import (
	"errors"
	"fmt"
	"os"

	"github.com/raibru/gobooklet/generator"
	"github.com/raibru/gobooklet/printer"
	"github.com/spf13/cobra"
)

var (
	year            int
	dumpDays        bool
	dumpDaysByWeek  bool
	dumpDaysByMonth bool
	outputDir       string
	cleanImgs       bool
	prtVersion      bool
)

var rootCmd = &cobra.Command{
	Use:   "gobooklet",
	Short: "Booklet creator based on templates",
	Long: `
Create booklets based on templates. Templetes are image files in png. See subcommands.
	`,
	Run: func(cmd *cobra.Command, args []string) {
		if cerr, err := handleGlobalParams(cmd, args); err != nil {
			cmd.Help()
			fmt.Printf("*** Error: Root command parsing error: \n%s", err)
			if cerr == 0 {
				cerr = 1
			}
			os.Exit(cerr)
		}
	},
}

// Execute the root command
func Execute() {
	if err := rootCmd.Execute(); err != nil {
		fmt.Printf("*** Error: parsing command has error: \n%s\n", err)
		os.Exit(1)
	}
}

func init() {
	rootCmd.PersistentFlags().BoolVarP(&dumpDays, "dump-days", "", false, "dump all generated days with formatted output")
	rootCmd.PersistentFlags().BoolVarP(&dumpDaysByWeek, "dump-weeks", "", false, "dump all generated days grouped by week with formatted output")
	rootCmd.PersistentFlags().BoolVarP(&dumpDaysByMonth, "dump-months", "", false, "dump all generated days grouped by month with formatted output")
	rootCmd.PersistentFlags().StringVarP(&outputDir, "output-dir", "O", ".", "Output Directory of formatted files")
	rootCmd.PersistentFlags().BoolVarP(&cleanImgs, "clean-images", "c", false, "clean all created images after booklet build process (default: false)")
	rootCmd.PersistentFlags().IntVarP(&year, "year", "y", 0, "year to build the booklet (is mandentory)")
	rootCmd.PersistentFlags().BoolVarP(&prtVersion, "version", "v", false, "display pktdump version")
}

func handleGlobalParams(cmd *cobra.Command, args []string) (cerr int, err error) {
	if prtVersion {
		PrintVersion(os.Stdout)
	} else if cleanImgs {
		fmt.Println("... clean build images after booklet creation")
	} else if year == 0 {
		fmt.Println("... check mandatory parameter year")
		err = errors.New("must have mandentory parameter year")
		return 2, err
	} else if year > 0 {
		if dumpDays {
			fmt.Println("... generate year with date items")
			days := generator.GenerateYearDays(year)
			fmt.Println("... use pretty print by date")
			printer.PrettyPrintByDate(days)
		}
		if dumpDaysByWeek {
			fmt.Println("... generate year with date per week items")
			daysByWeek := generator.GenerateFullWeeksForYear(year)
			fmt.Println("... use pretty print dates grouped by week")
			printer.PrettyPrintGroupedByWeek(daysByWeek)
		}
		if dumpDaysByMonth {
			fmt.Println("... generate year with date items")
			days := generator.GenerateYearDays(year)
			fmt.Println("... use pretty print dates grouped by month")
			printer.PrettyPrintGroupedByMonth(year, days)
		}
	} else {
		cmd.Help()
	}

	return 0, nil
}
