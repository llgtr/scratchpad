(ns vihkonen.components.main
  (:require [clojure.string :as str]
            [goog.string :as gstr]))

(defn mm->mmmm [month]
  (case month
    "01" "January"
    "02" "February"
    "03" "March"
    "04" "April"
    "05" "May"
    "06" "June"
    "07" "July"
    "08" "August"
    "09" "September"
    "10" "October"
    "11" "November"
    "12" "December"))

(defn format-two-decimals [e]
  (gstr/format "%.2f" e))

(defn totals-row [mapped-transactions]
  (let [out (->> mapped-transactions
                 (filter neg?)
                 (reduce +))
        in (->> mapped-transactions
                (filter pos?)
                (reduce +))]
     [:p "Totals: " (format-two-decimals out) ", +" (format-two-decimals in)]))

(defn payee-breakdown-card [transactions amount->float]
  (let [breakdown (->> transactions
                       (group-by :title)
                       (map (fn [[k v]] [k (reduce + (map amount->float v))]))
                       (filter (fn [[_ v]] (neg? v)))
                       (sort-by second)
                       (take 5))]
    [:div
     [:h4 {:style {:border-bottom "4px solid black" :margin-top "20px"}}
      "Highest by payee"]
     (for [[payee amount] breakdown]
       ^{:key (gensym)} [:p payee ", " (format-two-decimals amount)])]))

(defn card [month-mm transactions]
  (let [amount->float (comp js/parseFloat #(str/replace % #"," ".") :amount)
        map-to-float (map amount->float transactions)
        largest-out (apply min map-to-float)]

    [:div {:style {:background "whitesmoke"
                   :margin "0 20px"
                   :padding "10px"
                   :border "4px solid black"
                   :box-shadow "10px 10px 0px black"}}
     [:div {:style {:border-bottom "4px solid black"}}
      [:h2 (mm->mmmm month-mm)]]
     (totals-row map-to-float)
     [:p "Largest: " (format-two-decimals largest-out)]
     (payee-breakdown-card transactions amount->float)]))

(defn main-container [items]
  (let [get-month #(second (str/split (% :date) #"\."))]
    [:div {:style {:display "flex" :flex-direction "row" :margin-top "50px"}}
     (for [[bin group] (->> (items true) (group-by get-month) (sort-by first))]
       ^{:key (gensym)} [card bin group])]))

;; TODO: Add middle element "→"
