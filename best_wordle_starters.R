# ------------------------------------------------------------------------------
# Program: best_wordle_starters.R
#  Author: Floris Huider
#    Date: 04-02-2022
#
#   Email: f.huider@vu.nl
# -------|---------|---------|---------|---------|---------|---------|---------|

# Preparation
# ------------------------------------------------------------------------------
zscore <- function(x){
  (x - mean(x, na.rm = T)) / sd(x, na.rm = T)
}

# Load in data and limit to 5-letter words
# ------------------------------------------------------------------------------
english_words_all <- read.table("english_words_all.txt")
english_words_5 <- as.data.frame(english_words_all[nchar(as.character(english_words_all$V1))==5,]); colnames(english_words_5)[1] <- "V1"

# Generate random list with 300 combinations of 3, 5-letter words with no duplicate letters within or between them.
# ------------------------------------------------------------------------------
{
  wordstoletters <- strsplit(english_words_5$V1, split = "")
  duplist <- list()
  x <- 0
  for(i in 1:length(wordstoletters)){
    if(TRUE %in% duplicated(wordstoletters[[i]])){
      x = x + 1
      duplist[[x]] <- i
    }
  }
  english_words_5_nodups <- english_words_5[-which(rownames(english_words_5) %in% duplist),]
}

out <- tryCatch(
  {
  wordsets_nodubs <- list()
  for(i in 1:60){
    word1 <- sample(english_words_5_nodups, 1)
    letters1 <- unlist(strsplit(word1, split = ""))
    english_words_5_noletters1 <- grep(pattern = paste(letters1, collapse="|"), english_words_5_nodups, value = T, invert = T)
    word2 <- sample(english_words_5_noletters1, 1)
    letters2 <- unlist(strsplit(word2, split = ""))
    english_words_5_noletters2 <- grep(pattern = paste(letters2, collapse="|"), english_words_5_noletters1, value = T, invert = T)
    word3 <- sample(english_words_5_noletters2, 1)
    wordsets_nodubs[[i]] <- c(word1, word2, word3)
    }
  },
  error=function(cond){
    return("Oops, I ran into problems creating random unique wordsets. Please run the script again.")
  }
)

# Assign ranking scores to words based on their letter composition. No duplicate letters:
{
  lettercounts <- unlist(strsplit(english_words_5_nodups, split = ""))
  table(lettercounts)
  round(100*table(lettercounts) / sum(table(lettercounts)),1)
  lettercounts_df <- as.data.frame(table(lettercounts))
  lettercounts_ordered_df <- lettercounts_df[order(lettercounts_df$Freq, decreasing = T),]
  lettercounts_ordered_df$rank <- 1:nrow(lettercounts_ordered_df)
  lettercounts_ordered_df$prop <- lettercounts_ordered_df$Freq / sum(lettercounts_ordered_df$Freq)
  lettercounts_ordered_df$zscore <- zscore(lettercounts_ordered_df$Freq)

  wordstoletters <- strsplit(english_words_5_nodups, split = "")
  
  y = 0
  sum_list <- list()
  for(i in wordstoletters){
    x = 0
    y = y + 1
    for(j in i){
      x = x + lettercounts_ordered_df$zscore[lettercounts_ordered_df$lettercounts == j]
    }
    sum_list[[y]] <- x
  }
  english_words_5_nodups <- as.data.frame(english_words_5_nodups); colnames(english_words_5_nodups)[1] <- "V1"
  english_words_5_nodups$V2 <- as.numeric(sum_list) # This assigns the 'value' to each word! May require an abs() of the zscore values, not sure yet.
  english_words_5_nodups <- english_words_5_nodups[order(english_words_5_nodups$V2, decreasing = T),]
}

# Assign ranking to the wordsets based on z-scores, without duplicate letters.
{
  y = 0
  w = 0
  sum_list <- list()
  sum_sum_list <- list()
  for(i in wordsets_nodubs){
    x = 0
    y = y + 1
    for(j in i){
      w = w + 1
      z <- unlist(strsplit(j, split = ""))
      for(k in z){
        x = x + lettercounts_ordered_df$zscore[lettercounts_ordered_df$lettercounts == k]
      }
      sum_list[[w]] <- x
    }
    sum_sum_list[[y]] <- sum(unlist(sum_list))
    sum_list <- list()
  }
  wordsets_nodubs_df <- as.data.frame(t(as.data.frame(wordsets_nodubs)))
  rownames(wordsets_nodubs_df) <- c(1:length(rownames(wordsets_nodubs_df))); colnames(wordsets_nodubs_df) <- c("word1", "word2", "word3")
  wordsets_nodubs_df$ranking <- unlist(sum_sum_list)
  wordsets_nodubs_df_rankedonzscore <- wordsets_nodubs_df[order(wordsets_nodubs_df$ranking, decreasing = T),]
}

colnames(english_words_5_nodups) <- c("word", "ranking")

print(head(english_words_5_nodups[,1:2], n = 15), row.names = F)
print(head(wordsets_nodubs_df_rankedonzscore, n = 15), row.names = F)

write.table(english_words_5_nodups, "best_single_word_starters.txt", quote = F, row.names = F)
write.table(wordsets_nodubs_df_rankedonzscore, "best_three_word_starters.txt", quote = F, row.names = F)
