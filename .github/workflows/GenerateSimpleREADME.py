import re
import os

INPUT_FILE: str = "./README_full.md"
OUTPUT_FILE: str = "../../README.md"
SIMPLE_MESSAGE_FILE: str = "./simple_message.md"
IMAGES_PATH: str = "../../README_images"

with open(OUTPUT_FILE, mode="w", encoding="utf-8") as output_file:
	pass
with open(INPUT_FILE, mode="r", encoding="utf-8") as input_file:
	with open(OUTPUT_FILE, mode="a", encoding="utf-8") as output_file:
		line_prev: str = ""
		ignore_next_line: bool = False
		for line in input_file:
			if re.search(r"<!-- .+ -->", line):
				if "SIMPLE_MESSAGE" in line:
					with open(SIMPLE_MESSAGE_FILE, mode="r", encoding="utf-8") as simple_message:
						for simple_message_line in simple_message:
							if "FILE_SIZE" in simple_message_line:
								total_size: int = 0
								with os.scandir(IMAGES_PATH) as images:
									for image in images:
										total_size += image.stat().st_size
								output_file.write(simple_message_line.replace("<!-- FILE_SIZE -->", str(round(total_size / 1048576))))
							else:
								output_file.write(simple_message_line)
			else:
				if re.search(r"[ \t]*!\[.+\]\(.+\)", line) and not "<!-- REQUIRED_IMAGE -->" in line_prev:
					ignore_next_line = True
				elif not ignore_next_line:
					output_file.write(line.replace("../../", ""))
				else:
					ignore_next_line = False
			line_prev = line