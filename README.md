# SeismicApp

[![Codacy Badge](https://api.codacy.com/project/badge/Grade/541399edde8643c8ab41fe3942207cc8)](https://www.codacy.com/app/de5pair/SeismicApp?utm_source=github.com&utm_medium=referral&utm_content=de5pair/SeismicApp&utm_campaign=badger)

### What's this for?

This app tries to help Chilean people to better understand earthquakes and how to be ready when one strikes

### Before you start

You need to create an account or login. (This will be used later to store your "earthquake plan"(coming soon))
This is done thanks to parse API.

### App Parts

The app is divided in 4 sections

##### Informacion

###### Sismos

Shows information about earthquakes (what are they, and their scales: richter and mercalli)

###### Prevención

Shows information about how to be prepared in case of an earthquake (Safe places, what to do and what to have on a survival pack)

#### Desafíos

This are 2 kinds of challenges created to help people learn about earthquakes
Using a simplification of the [Leitner System](https://en.wikipedia.org/wiki/Leitner_system) the app will help the user learn concepts associated with earthquakes.
In this phase of the app the user will have to create his/hers own flashcards/quizzes. Later an automated api will be created to automatically generate those first flashcards/quizzes.

###### Flashcards

The user has to create a deck before adding flashcards to it.
Then he/she can add flashcards (or delete them by swiping left).
And after adding flashcards to a deck, the user can play and try to guess the concept associated with the flashcard.
Then the user has to rate his performance, and based on this the app will asign a "knowledge level" of that concept to the card, to us this variable in the Leitner System.

###### Quiz

The user has to create a question and 3 answers (1 right, 2 wrong) before starting a quiz.
Starting a game, the user will be asked one of the questions stored in the database.
If the user answers it right, the question gets a "level up". Otherwise, if the user gets it wrong, the question gets a "level down".
This levels are used to pick the next question to be asked, based on the Leitner System.

#### Sismos de Hoy

The earthquakes will be retrieved using the USGS Rest API.
If an earthquake has occured today in Chile (for this demo, i've commented the Chile filter, so it will display every earthquake that has ocurred in the las 24 hours), will be shown as a row in a table, showing the magnitude, name and date of ocurrence.
If the user clicks a row, will be able to see in a map a representation of the earthquake's location with more information about that earthquake.

#### Mi Plan

This is currently a placeholder view showing information about how will be implemented (soon).
