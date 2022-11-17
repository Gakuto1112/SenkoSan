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
					image_before = re.search(r"^ +", line)
					image_title = re.search(r"!\[.+\]", line).group()[2:-1]
					image_path = re.search(r"\(.+\)", line).group()[1:-1].replace("../../", "")
					output_file.write(f"{image_before.group() if not image_before is None else ''}[[画像] {image_title}]({image_path})")
				else:
					output_file.write(line.replace("../../", ""))
			line_prev = line