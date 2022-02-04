# Conquer Wordle

With the rising popularity of [Wordle](https://www.powerlanguage.co.uk/wordle/) there is an increasing need for semi-scientific analyses of the English language to identify the best game strategy. The script 'best_wordle_starters.R' reads in a +370k list of words from the English dictionary (procured by [DWYL](https://github.com/dwyl/english-words)) to identify the 5-letter words that grant you the best chance at conquering the game and impressing your Twitter followers.

Requirements:
- The R software (+ Rstudio, optionally)
- best_wordle_starters.R
- english_words_all.txt

To obtain a ranked list of the best starter words and 3-word combinations, either open the script in Rstudio and run (ctrl+enter) its content, or run it from the terminal ("Rscript best_wordle_starters.R", without quotation marks). The script assumes that the script (best_wordle_starters.R) and data (english_words_all.txt) are stored in the same directory.

How does it work? In short, the script reads in a list of +370k words from the English dictionary, limits the list to 5-letter words and excludes words with duplicate letters. From this single-word list it randomly selects 60 3-word combinations (wordsets) that each consist of non-overlapping letters to optimize the alphabetic ground they cover.   The script then computes scores for each letter in the alphabet based on the frequency at which these letters occur in the 5-letter word list. These 'letter scores' are then compiled into 'word scores', and assigned to to the single-word openers and the 3-word combinations. The script outputs the top 10 single- and 3-word starting guesses that will grant you the best chances at success!

An example of its application: After running the script, I obtained a list of the most advantageous 3-word starters. Using the words from the highest ranking wordset led me to guess the word on my fourth try. 
![conquer_wordle_example](https://user-images.githubusercontent.com/49392075/152574661-d55c197a-b835-42ae-aa06-563a7ab8f4a7.png)

Please note that for the wordsets, the script generates at random 60 combinations of uniquely-lettered words, assigns weight to the combinations, and then ranks the best combination among the current collection of randomly created wordsets. This means that the ‘best-ranking’ wordset ranks best within the current random selection, and does not represent a universal, most ideal strategy. Also, occassionaly the the random nature of the wordset generation can result in error due to a lack of remain word options. When you encounter this error, simply rerunning the script once or twice usually solves the issue. Finally, the current algorithm does not take letter position into consideration (e.g. an ‘A’ at position 1 may be more advantageous than an ‘A’ at position 3). This feature may be added in the future. 

Sidenote: This was just a fun experiment, I'm sure that others have build similar algorithms that far exceed mine in terms of elegance and efficiency. Regardless, I learnt a lot from writing this script, and I hope it brings joy to some. 
