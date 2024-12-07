;MCN 7105
;END OF SEMESTER PROJECT
;Student name: GOLOLA CHARLES
;Reg. No. 2024/HD05/21923U
;Student Number: 2400721923
;Programme: MCS


#lang racket
(require net/url)
(require data-science-master)
(require plot)
(require math)

;; ------------------------------
;; Abstractions
;; ------------------------------

;; --- 1. TweetProcessor: Handles data loading and cleaning
  ;; Load tweets from a CSV file
(define (load-tweets csv-path)
  (read-csv csv-path #:header? #t))



  ;; Preprocess and clean tweet text
(define (clean-tweet text)
  (string-normalize-spaces
   (remove-punctuation
    (remove-urls
     (string-downcase text)))))




;; --- 2. SentimentAnalyzer: Analyzes sentiment from cleaned tweets
  ;; Analyze sentiment for a list of cleaned tweets grouped by month
(define (analyze-sentiment cleaned-tweets lexicon)
  (define all-cleaned-text (string-join cleaned-tweets " "))
  (define words (document->tokens all-cleaned-text #:sort? #t))
  (list->sentiment words #:lexicon lexicon))




;; Aggregates sentiment data (sum of sentiment weighted by frequency)
(define (aggregate-sentiment sentiment-data)
  (aggregate sum ($ sentiment-data 'sentiment) ($ sentiment-data 'freq)))





;; --- 3. VisualizationModule: Plots sentiment trends
(define (plot-sentiment aggregated-sentiment)
  (parameterize ((plot-width 800))
    (plot (list
           (tick-grid)
           (discrete-histogram
            aggregated-sentiment
            #:color "MediumSlateBlue"
            #:line-color "MediumSlateBlue"))
          #:x-label "Affective Label"
          #:y-label "Frequency")))






;; ------------------------------
;; Main Program
;; ------------------------------
;; Load the dataset
(define twitter-data (load-tweets "uganda.csv"))



;; Extract the required fields from the dataset
(define created-at-column ($ twitter-data 'created_at))
(define text-column ($ twitter-data 'text))




;; Clean the tweet data
(define cleaned-tweets (map clean-tweet text-column))




;; Analyze sentiment of the cleaned tweets
(define sentiment (analyze-sentiment cleaned-tweets 'nrc))




;; Aggregate sentiment data
(define aggregated-sentiment (aggregate-sentiment sentiment))



;; Plot sentiment visualizations
(plot-sentiment aggregated-sentiment)
