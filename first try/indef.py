#!/usr/bin/env python
#

import sys
import os
import string
import re

# Set up searches:
findGalaxy = re.compile('INDEF')

def ConvertIndef( fileName ):
	tempFileName = fileName + "_temp"
	try:
		# Get lines from file
		theLines = open(fileName).readlines()
		
		if len(theLines) > 0:
			outFile = open(tempFileName, 'w')
			for currentLine in theLines:
				newLine = currentLine.replace('INDEF', '0.000')
				outFile.write(newLine)
			outFile.close()

			# replace old file with new version:
			os.rename(tempFileName, fileName)

		else:
			print "File %s is apparently empty." % (fileName)

	except (IOError):
		print "File %s not found." % (fileName)



if __name__ == '__main__':

	if len(sys.argv) > 1:
		for i in range(1, len(sys.argv)):
			ConvertIndef( sys.argv[i] )
	else:
		print "indef.py needs a list of filenames."
