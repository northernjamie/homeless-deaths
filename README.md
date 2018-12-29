# homeless-deaths
Resources for homeless deaths maps

The data here came from the Bureau Of Investigative Journalism https://www.thebureauinvestigates.com/projects/homelessness/open-resources

Data has been sourced from combination of Freedom of Information requests, and media reports

I then geocoded the 2018 deaths and mapped them.

I used R to make the frames for the gif. Pretty sure there's a way to do similar in QGIS, but I sacked it off after half an hour of trying and reverted to what I know.

## Limitations

* There were an additional 48 deaths in scotland where the data of death was : "Between 1 Oct 2017 and 13 April 2018". These have been disregarded for this visualisation.

* There are an additional 103 deaths in Northern Ireland, where the date of death is not known - only the date that the person was removed from a housing register. These have been disregarded for this visualisation.

* Where only the year was reported, these deaths have defaulted to the 1st Jan 2018. Where only the month and year have been reported, these have defaulted to the 1st day of the month.

* ONS have since estimated a higher number of deaths to homeless people.


