from pathlib import Path

# Variable Declarations
beginNumber = 1
endNumber = 5
base_path = Path(f"C:/temp/") # or just C:/temp/

subFolders = ["C-Sharp", "Python", "PowerShell"]

# Looping and create a directory if that is not exists.
for i in range(beginNumber, endNumber+1):
  print(f"Day {i}")

  # Option 1
  # day_folder = Path(f"{base_path}Day {i}")

  # Option 2 == simplied way only if base_path defined as Path(C:/temp/)
  day_folder = base_path / f"Day {i}"
  
  #if not day_folder.exists():
  day_folder.mkdir(parents=True, exist_ok = True)
  print(f"Folder Name: {f"Day {i}"} and this folder created in this location: '{base_path}'")
  
  # Create sub-folders in each Day wise folder
  for sub in subFolders:
     sub_folder_path = day_folder / sub #Path(f"{day_folder}\{sub}")
     #if not sub_folder_path.exists():
     sub_folder_path.mkdir(parents=True, exist_ok = True)
     tempFile = sub_folder_path / ".gitkeep" #Path(f"{sub_folder_path}\.gitkeep")
        #if not tempFile.exists():
     tempFile.touch(exist_ok=True)
     print(f"Sub Folder Name: {sub} and this folder created in this location: '{day_folder}'")
  
