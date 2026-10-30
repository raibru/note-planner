

## Notes

- Booklet PDF 1st-Pages

```sh
$ pdfjam --a4paper --nup 2x2 --scale 0.85 \
    --trim '-4mm -14mm -4mm -14mm' \
    --frame true \
    --outfile TNPassort-booklet-2026-1.pdf \
    TNPassportMonthCal-2026.pdf \
    "28,1,26,3,24,5,22,7,20,9,18,11,16,13"
```
- Booklet PDF 2nd-Pages

```sh
$ pdfjam --a4paper --nup 2x2 --scale 0.85 \
    --trim '-4mm -14mm -4mm -14mm' \
    --frame true \
    --outfile TNPassort-booklet-2026-2.pdf \
    TNPassportMonthCal-2026.pdf \
    "2,27,4,25,6,23,8,21,10,19,12,17,14,15"
```
- Drucken Booklet PDF 1st-Pages: TNPassort-booklet-2026-1.pdf
- nach dem Druck: Seiten sortieren reverse
- Längsseite drehen 180° in Druckschacht
- Drucken Booklet PDF 2nd-Pages: TNPassort-booklet-2026-2.pdf
