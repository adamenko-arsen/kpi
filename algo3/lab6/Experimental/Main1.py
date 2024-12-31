import tkinter as tk
from tkinter import messagebox
import random

class YahtzeeGUI:
    def __init__(self, root):
        self.root = root
        self.root.title("Yahtzee")
        
        self.categories = [
            "Ones", "Twos", "Threes", "Fours", "Fives", "Sixes",
            "Three of a Kind", "Four of a Kind", "Full House",
            "Small Straight", "Large Straight", "Yahtzee", "Chance"
        ]

        self.player_scores = {}
        self.bot_scores = {}
        self.dice = [0] * 5
        self.roll_buttons = []
        self.category_buttons = []

        self.create_widgets()

    def create_widgets(self):
        self.dice_labels = [tk.Label(self.root, text="0", font=("Arial", 16)) for _ in range(5)]
        for i, label in enumerate(self.dice_labels):
            label.grid(row=0, column=i)

        self.roll_button = tk.Button(self.root, text="Roll Dice", command=self.roll_dice)
        self.roll_button.grid(row=1, column=0, columnspan=5)

        self.categories_frame = tk.LabelFrame(self.root, text="Categories", padx=10, pady=10)
        self.categories_frame.grid(row=2, column=0, columnspan=5)

        for category in self.categories:
            button = tk.Button(self.categories_frame, text=category, command=lambda c=category: self.player_choose_category(c))
            button.pack(fill=tk.X)
            self.category_buttons.append(button)

        self.bot_score_label = tk.Label(self.root, text="Bot Score: 0", font=("Arial", 14))
        self.bot_score_label.grid(row=3, column=0, columnspan=2)

        self.player_score_label = tk.Label(self.root, text="Your Score: 0", font=("Arial", 14))
        self.player_score_label.grid(row=3, column=3, columnspan=2)

    def roll_dice(self):
        for i in range(5):
            self.dice[i] = random.randint(1, 6)
            self.dice_labels[i].config(text=str(self.dice[i]))

    def player_choose_category(self, category):
        if category in self.player_scores:
            messagebox.showerror("Error", "You already chose this category!")
            return

        score = self.calculate_score(category)
        self.player_scores[category] = score
        self.update_score_display()

        self.bot_turn()
        self.check_game_end()

    def calculate_score(self, category):
        counts = {i: self.dice.count(i) for i in range(1, 7)}

        if category == "Ones":
            return counts[1] * 1
        elif category == "Twos":
            return counts[2] * 2
        elif category == "Threes":
            return counts[3] * 3
        elif category == "Fours":
            return counts[4] * 4
        elif category == "Fives":
            return counts[5] * 5
        elif category == "Sixes":
            return counts[6] * 6
        elif category == "Three of a Kind":
            return sum(self.dice) if max(counts.values()) >= 3 else 0
        elif category == "Four of a Kind":
            return sum(self.dice) if max(counts.values()) >= 4 else 0
        elif category == "Full House":
            return 25 if sorted(counts.values(), reverse=True)[:2] == [3, 2] else 0
        elif category == "Small Straight":
            straights = [{1, 2, 3, 4}, {2, 3, 4, 5}, {3, 4, 5, 6}]
            return 30 if any(set(self.dice) >= s for s in straights) else 0
        elif category == "Large Straight":
            return 40 if set(self.dice) in [{1, 2, 3, 4, 5}, {2, 3, 4, 5, 6}] else 0
        elif category == "Yahtzee":
            return 50 if max(counts.values()) == 5 else 0
        elif category == "Chance":
            return sum(self.dice)
        return 0

    def bot_turn(self):
        available_categories = [c for c in self.categories if c not in self.bot_scores]
        if not available_categories:
            return

        best_category = random.choice(available_categories)
        self.bot_scores[best_category] = self.calculate_score(best_category)
        self.update_score_display()

    def update_score_display(self):
        self.player_score_label.config(text=f"Your Score: {sum(self.player_scores.values())}")
        self.bot_score_label.config(text=f"Bot Score: {sum(self.bot_scores.values())}")

    def check_game_end(self):
        if len(self.player_scores) == 13:
            player_total = sum(self.player_scores.values())
            bot_total = sum(self.bot_scores.values())

            if player_total > bot_total:
                messagebox.showinfo("Game Over", "You win!")
            elif player_total < bot_total:
                messagebox.showinfo("Game Over", "Bot wins!")
            else:
                messagebox.showinfo("Game Over", "It's a tie!")

            self.root.quit()

if __name__ == "__main__":
    root = tk.Tk()
    game = YahtzeeGUI(root)
    root.mainloop()
