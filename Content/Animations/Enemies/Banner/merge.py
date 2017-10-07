#!/usr/bin/python

# Image Merge - For Creating Spritesheets - v0.3
# Copyright (C) 2006 - 2008 Chris 'fydo' Hopp
# Web: fydo.net	E-Mail: fydo@fydo.net

# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# A copy of the GPL is available at http://www.gnu.org/copyleft/gpl.html
# and should also be included as gpl.txt

#
#	Requirements:
#		Python
#		PIL
#
# This script also requires a blank .png file (blank.png)
#  to be present as well.
#
# Pass in any number of image files and this script will merge them (from 
#  left to right in the order they were passed in) into one large, wide
#  image. 
# New in v0.3 is the ability to merge images vertically.
#
# It is important to note that all of the images passed in must
#  be of the same height. Differing widths is supported by this script.
# If you are using the vertical merge, the opposite is true. (Images
#  must be the same width, varying heights are allowed)
#
# Special Thanks to the following people for helping me with testing:
#	RoeBros[0]
#

# Import the needed libraries
import os, sys

#Variable to track if the user wants to merge vertically or not.
vert = False

# First we shall handle the arguments
if len(sys.argv) < 2:
	print 'Incorrect usage. Try \'merge.py --help\' for more information.'
	sys.exit()

# Now we'll look for anyone looking for help or version numbers
if sys.argv[1].startswith('--'):
	option = sys.argv[1][2:]
	if option == 'version':
		sys.exit()
	elif option == 'vert':
		vert = True
	elif option == 'help':
		print '''\
Image Merge (merge.py) - by Chris 'fydo' Hopp - v0.3

This script will build a spritesheet based on .png files passed into it.
Any number of .png files may be specified.

Example of usage:
	merge.py (--vert) one.png two.png three.png

Additional options:
	--version	: Displays the version number
	--vert		: Merge files vertically instead of horizontally
	--help		: Displays this utterly helpful help message
'''
		sys.exit()
	else:
		print 'Unknown option.'
		sys.exit()

# Now check to ensure that all of the files actually exist
if vert:
	# check again to be sure files have been specified
	if len(sys.argv) < 3:
		print 'Incorrect usage. Try \'merge.py --help\' for more information.'
		sys.exit()

	for arg in sys.argv[2:]:
		if not os.path.exists(arg):
			print 'The file', arg, 'does not exist. Exiting ...'
			sys.exit()
else:
	for arg in sys.argv[1:]:
		if not os.path.exists(arg):
			print 'The file', arg, 'does not exist. Exiting ...'
			sys.exit()

try:
	from PIL import Image
	# PIL requires the blank.png file to exist
	if not os.path.exists('blank.png'):
		print 'This script requires \'blank.png\' to be present. Exiting ...'
		sys.exit()
except ImportError:
	print 'The PIL library was not found. Check http://www.pythonware.com/products/pil/ \nExiting ...'
	sys.exit()

def main(argv, vert):

	# Initialize stuff ...
	neww = 0
	newh = 0
	count = 0
	sub_images = []
	
	print ' ' # Just to make things look a little nicer :)

	if vert:
		# Merging vertically

		for arg in argv[1:]:
			# Show everyone we're currently processing this file
			print "Processing: " + arg
			
			# Open the file
			try:
				sub_images.append(Image.open(arg))
			except:
				print "Error loading file", arg
				return
			
			# Grab the dimensions		
			neww = sub_images[count].size[0]
			newh += sub_images[count].size[1]

			count += 1
		
		# Load that blank.png file
		try:
			im = Image.open("blank.png")
		except:
			print "Error loading file blank.png"
			return
		
		# Resize that blank.png file
		im = im.resize((neww, newh))

		# Loop through all the images and append them to that blank.png file
		for y in range(count):
				im.paste(sub_images[y], (0, (y * sub_images[y].size[1])))

		# All done! Saving time!
		im.save("out.png")
		
		# Report to the user
		print '\nMerged', count, 'images.', im.size[0], 'x', im.size[1], 'image saved as out.png.\nThanks for using merge.py!'

	else:
		# Merging horizontally
		
		# Gather data about each individual image file
		for arg in argv:

			# Show everyone we're currently processing this file
			print "Processing: " + arg
			
			# Open the file
			try:
				sub_images.append(Image.open(arg))
			except:
				print "Error loading file", arg
				return
	
			# Grab the dimensions		
			neww += sub_images[count].size[0]
			newh = sub_images[count].size[1]
	
			# Incrementation!
			count += 1
	
		# Load that blank.png file
		try:
			im = Image.open("blank.png")
		except:
			print "Error loading file blank.png"
			return

		# Resize that blank.png file
		im = im.resize((neww, newh))
	
		# Loop through all the images and append them to that blank.png file
		for y in range(count):
			im.paste(sub_images[y], (y * sub_images[y].size[0], 0))
	
		# All done! Saving time!
		im.save("out.png")

		# Report to the user
		print '\nMerged', count, 'images.', im.size[0], 'x', im.size[1], 'image saved as out.png.\nThanks for using merge.py!'
	
if __name__ == "__main__":
	print 'Image Merge (merge.py) - by Chris \'fydo\' Hopp - v0.3'
	main(sys.argv[1:], vert) # Don't want the very first arg, which is the executable name