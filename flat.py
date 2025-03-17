import os
import tkinter as tk
from tkinter import filedialog, messagebox
from tkinter.scrolledtext import ScrolledText

class TextExtractorApp:
    def __init__(self, master):
        self.master = master
        master.title("Text Extractor")
        master.geometry("800x600")

        self.selected_folder = None
        self.extracted_text = ""

        self.select_folder_button = tk.Button(master, text="Select Folder", command=self.select_folder)
        self.select_folder_button.pack(pady=10)

        self.selected_folder_label = tk.Label(master, text="No folder selected")
        self.selected_folder_label.pack()

        self.text_area = ScrolledText(master, wrap=tk.WORD, height=25)
        self.text_area.pack(expand=True, fill='both', padx=10, pady=10)

        self.copy_button = tk.Button(master, text="Copy to Clipboard", command=self.copy_to_clipboard)
        self.copy_button.pack(pady=10)

    def select_folder(self):
        folder_selected = filedialog.askdirectory()
        if folder_selected:
            self.selected_folder = folder_selected
            self.selected_folder_label.config(text=f"Selected folder: {folder_selected}")
            self.process_folder(folder_selected)

    def process_folder(self, folder_path):
        self.extracted_text = ""
        for root, _, files in os.walk(folder_path):
            for file in files:
                file_path = os.path.join(root, file)
                # Only process files with an extension
                if os.path.splitext(file)[1]:
                    try:
                        with open(file_path, "r", encoding="utf-8") as f:
                            content = f.read()
                    except Exception:
                        # Skip files that can't be read as text
                        continue
                    relative_path = os.path.relpath(file_path, folder_path)
                    self.extracted_text += f"{relative_path}:\n{content}\n\n"
        self.text_area.delete("1.0", tk.END)
        self.text_area.insert(tk.END, self.extracted_text)

    def copy_to_clipboard(self):
        self.master.clipboard_clear()
        self.master.clipboard_append(self.extracted_text)
        messagebox.showinfo("Info", "Text copied to clipboard!")

root = tk.Tk()
app = TextExtractorApp(root)
root.mainloop()
