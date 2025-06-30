from kivy.app import App
from kivy.uix.screenmanager import ScreenManager, Screen
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.label import Label
from kivy.uix.textinput import TextInput
from kivy.uix.button import Button
import random

USERNAME = "user"
PASSWORD = "1234"

class LoginScreen(Screen):
    def __init__(self, **kwargs):
        super(LoginScreen, self).__init__(**kwargs)
        layout = BoxLayout(orientation='vertical', padding=20, spacing=10)
        self.username = TextInput(hint_text='Username', multiline=False)
        self.password = TextInput(hint_text='Password', multiline=False, password=True)
        self.message = Label(text='')
        login_btn = Button(text='Login')
        login_btn.bind(on_press=self.check_login)

        layout.add_widget(Label(text="Login"))
        layout.add_widget(self.username)
        layout.add_widget(self.password)
        layout.add_widget(login_btn)
        layout.add_widget(self.message)
        self.add_widget(layout)

    def check_login(self, instance):
        if self.username.text == USERNAME and self.password.text == PASSWORD:
            self.manager.current = 'game'
        else:
            self.message.text = 'Invalid credentials!'

class GameScreen(Screen):
    def __init__(self, **kwargs):
        super(GameScreen, self).__init__(**kwargs)
        self.number = random.randint(1, 10)
        layout = BoxLayout(orientation='vertical', padding=20, spacing=10)
        self.label = Label(text='Guess a number between 1 and 10')
        self.input = TextInput(hint_text='Your guess', multiline=False, input_filter='int')
        self.result = Label(text='')
        guess_btn = Button(text='Guess')
        guess_btn.bind(on_press=self.check_guess)

        layout.add_widget(self.label)
        layout.add_widget(self.input)
        layout.add_widget(guess_btn)
        layout.add_widget(self.result)
        self.add_widget(layout)

    def check_guess(self, instance):
        try:
            guess = int(self.input.text)
            if guess == self.number:
                self.result.text = "Correct!"
            elif guess < self.number:
                self.result.text = "Too low!"
            else:
                self.result.text = "Too high!"
        except:
            self.result.text = "Enter a valid number!"

class GuessApp(App):
    def build(self):
        sm = ScreenManager()
        sm.add_widget(LoginScreen(name='login'))
        sm.add_widget(GameScreen(name='game'))
        return sm

if __name__ == '__main__':
    GuessApp().run()
