
function debug.printLoadedPackages()
	
	print(table.toString( package.loaded, "package.loaded", true, 1 ))

end