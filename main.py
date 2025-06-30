# main.py

import random
from kivy.app import App
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.properties import ObjectProperty, StringProperty, NumericProperty
from kivy.lang import Builder
from kivy.uix.popup import Popup
from kivy.uix.label import Label
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.button import Button  # Import Button for the popup

# Load the Kivy UI definition from game.kv
Builder.load_file('game.kv')


class LoginScreen(Screen):
    """
    Represents the login screen of the application.
    Handles basic username/password input (placeholder for actual authentication).
    """
    username_input = ObjectProperty(None)
    password_input = ObjectProperty(None)
    login_message = StringProperty("Enter your credentials")

    def do_login(self):
        """
        Handles the login button click.
        A very simple, placeholder login logic.
        """
        username = self.username_input.text
        password = self.password_input.text

        # Simple placeholder login logic
        if username == "user" and password == "pass":
            self.manager.current = 'game'  # Switch to the game screen
            self.login_message = "Login successful!"
        else:
            self.login_message = "Invalid username or password!"


class GameScreen(Screen):
    """
    Represents the main game screen where the user guesses a number.
    """
    guess_input = ObjectProperty(None)
    result_label = StringProperty("Guess a number between 1 and 100!")
    attempts_label = StringProperty("Attempts: 0")

    _secret_number = NumericProperty(0)
    _attempts = NumericProperty(0)

    def on_enter(self, *args):
        """
        Called when the screen becomes active.
        Resets the game state and generates a new secret number.
        """
        self.reset_game()

    def reset_game(self):
        """
        Resets the game to its initial state: generates a new secret number,
        resets attempts, and clears input/result labels.
        """
        self._secret_number = random.randint(1, 100)
        self._attempts = 0
        self.result_label = "Guess a number between 1 and 100!"
        self.attempts_label = "Attempts: 0"
        self.guess_input.text = ""
        print(f"Secret number (for debug): {self._secret_number}")  # For debugging

    def check_guess(self):
        """
        Checks the user's guess against the secret number.
        Provides hints (higher/lower) and handles win/loss conditions.
        """
        try:
            guess = int(self.guess_input.text)
            self._attempts += 1
            self.attempts_label = f"Attempts: {self._attempts}"

            if guess < self._secret_number:
                self.result_label = "Too low! Try again."
            elif guess > self._secret_number:
                self.result_label = "Too high! Try again."
            else:
                self.result_label = f"Congratulations! You guessed it in {self._attempts} attempts!"
                self.show_win_popup()

        except ValueError:
            self.result_label = "Please enter a valid number."
        self.guess_input.text = ""  # Clear input after each guess

    def show_win_popup(self):
        """
        Displays a popup window when the user wins the game.
        Offers options to play again or return to the login screen.
        """
        box = BoxLayout(orientation='vertical', padding='10dp', spacing='10dp')
        box.add_widget(Label(text=f"You won in {self._attempts} attempts!", size_hint_y=None, height='40dp'))

        play_again_button = Button(text="Play Again", size_hint_y=None, height='40dp')
        back_to_login_button = Button(text="Back to Login", size_hint_y=None, height='40dp')

        popup = Popup(title='Game Over', content=box, size_hint=(0.9, 0.4))

        play_again_button.bind(on_release=lambda btn: self._play_again_action(popup))
        back_to_login_button.bind(on_release=lambda btn: self._back_to_login_action(popup))

        box.add_widget(play_again_button)
        box.add_widget(back_to_login_button)

        popup.open()

    def _play_again_action(self, popup):
        """Internal helper for 'Play Again' button in popup."""
        popup.dismiss()
        self.reset_game()

    def _back_to_login_action(self, popup):
        """Internal helper for 'Back to Login' button in popup."""
        popup.dismiss()
        self.manager.current = 'login'  # Switch back to login screen


class GuessingGameApp(App):
    """
    Main application class.
    Initializes the ScreenManager and adds the login and game screens.
    """

    def build(self):
        """
        Builds the root widget for the application.
        Creates a ScreenManager to handle screen transitions.
        """
        sm = ScreenManager()
        sm.add_widget(LoginScreen(name='login'))
        sm.add_widget(GameScreen(name='game'))
        return sm


if __name__ == '__main__':
    GuessingGameApp().run()
