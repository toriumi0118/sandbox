#! coding: utf-8
"""環境設定
"""

from datetime import datetime
import logging

date = datetime.now()
date_str = date.strftime("%Y%m%d-%H%M")
output_dir = "output/"

logging.basicConfig(filename=output_dir + date_str + "-log.log", format="%(asctime)s: %(levelname)s: %(message)s", level=logging.DEBUG)
