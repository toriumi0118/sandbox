Requirements:
	python > 3.4
	lxml-3.3.4.win32-py3.4.exe

	execute:
		pip install pyquery
		pip install pygeocoder

Usage:
	1. call getnumber_from_wamnet.py
		: you can get office numbers from wamnet.
		: (example) python getnumber_from_wamnet.py wamnet_numbers.csv [DAY | KYTAKU]

	2. call csvtodb.py
		: you can get full data of offices for office numbers in input-csv file.
		: (example) python csvtodb.py wamnet_numbers.csv DAY 
	
	3. You can execute csvtodb.rb next. Change project dir to csvtodb in sandbox.

Author: toriumi_y
