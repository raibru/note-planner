# note-planner

Build a planner for a given year to handle notes, task and event during this year. There are scripts to build from templates image a pdf in different formats used by notes system like Onyx Boox Note tablets. The note tools on the tablet handles the pure PDFs with the stylus. This will create planner for:

* Weekly Planner
* Daily Planner

## Play with date

```bash
>$ printf "\nDate\t\tDOW\tDOY\t%%U %%V %%W\n"; \
    for d in "Dec "{25..31}" 2026" \
    "Jan "{1..14}" 2027"; \
    do printf "%s\t" "$d"; \
    date -d "$d" +"%a%t%j%t%U %V %W"; \
    done

Results in:

Date            DOW     DOY     %U %V %W
Dec 25 2026     Fr      359     51 52 51
Dec 26 2026     Sa      360     51 52 51
Dec 27 2026     So      361     52 52 51
Dec 28 2026     Mo      362     52 53 52
Dec 29 2026     Di      363     52 53 52
Dec 30 2026     Mi      364     52 53 52
Dec 31 2026     Do      365     52 53 52
Jan 1 2027      Fr      001     00 53 00
Jan 2 2027      Sa      002     00 53 00
Jan 3 2027      So      003     01 53 00
Jan 4 2027      Mo      004     01 01 01
Jan 5 2027      Di      005     01 01 01
Jan 6 2027      Mi      006     01 01 01
Jan 7 2027      Do      007     01 01 01
Jan 8 2027      Fr      008     01 01 01
Jan 9 2027      Sa      009     01 01 01
Jan 10 2027     So      010     02 01 01
Jan 11 2027     Mo      011     02 02 02
Jan 12 2027     Di      012     02 02 02
Jan 13 2027     Mi      013     02 02 02
Jan 14 2027     Do      014     02 02 02
 ```

 ```bash
 $ printf "\nDate\t\tDOW\tDOY\t%%U %%V %%W\n"; for d in "Dec "{25..31}" 2026" "Jan "{1..14}" 2027"; do date -d "$d" +"%b %d %Y%t%a%t%j%t%U %V %W"; done

Date            DOW     DOY     %U %V %W
Dez 25 2026     Fr      359     51 52 51
Dez 26 2026     Sa      360     51 52 51
Dez 27 2026     So      361     52 52 51
Dez 28 2026     Mo      362     52 53 52
Dez 29 2026     Di      363     52 53 52
Dez 30 2026     Mi      364     52 53 52
Dez 31 2026     Do      365     52 53 52
Jan 01 2027     Fr      001     00 53 00
Jan 02 2027     Sa      002     00 53 00
Jan 03 2027     So      003     01 53 00
Jan 04 2027     Mo      004     01 01 01
Jan 05 2027     Di      005     01 01 01
Jan 06 2027     Mi      006     01 01 01
Jan 07 2027     Do      007     01 01 01
Jan 08 2027     Fr      008     01 01 01
Jan 09 2027     Sa      009     01 01 01
Jan 10 2027     So      010     02 01 01
Jan 11 2027     Mo      011     02 02 02
Jan 12 2027     Di      012     02 02 02
Jan 13 2027     Mi      013     02 02 02
Jan 14 2027     Do      014     02 02 02
```

## Build weekly booklet in Range

Change to directory ./src/scripts and execute following command:

```bash
for i in {2022..2049}; do ./build_tn_regular_cal_weekly.sh $i; done
```
