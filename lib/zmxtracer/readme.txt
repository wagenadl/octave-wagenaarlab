First, download Thorlabs webpages like "https://www.thorlabs.com/newgrouppage9.cfm?objectgroup_id=259" to the html/ folder.

Then, run "selectprods.sh" to create "prodnos.txt".

Then, run "getallprodpages.sh" to get the html files.

Then, run "getallzemax.sh" to get the Zemax files.

Finally, run "allzmx2m.sh" to create .m files for use in "tracer_addlens."

See "tracer_example.m" to get started.
