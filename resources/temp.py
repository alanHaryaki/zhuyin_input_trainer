text = """下馬飲君酒，問君何所之。君言不得意，歸臥南山陲。但去莫復問，白雲無盡時。"""

for char in text:
    if char not in ["，", "。", " "]:
        print(char)


