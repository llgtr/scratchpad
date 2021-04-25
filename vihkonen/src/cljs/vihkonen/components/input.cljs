(ns vihkonen.components.input
  (:require [clojure.string :as str])
  (:import [goog.labs.format csv]
           [goog.labs.format.csv ParseError]))

(defn translate-header [e]
  (case e
    "Kirjauspäivä" "date"
    "Määrä" "amount"
    "Maksaja" "payer"
    "Maksunsaaja" "payee"
    "Nimi" "name"
    "Otsikko" "title"
    "Viitenumero" "refnum"
    "Saldo" "balance"
    "Valuutta" "currency"))

(defn file-parser [f]
  (try
    (-> f
        (csv/parse nil ";")
        js->clj)
    (catch csv/ParseError e
      (let [msg (.-message e)]
        (println :err msg)
        msg))))

(defn get-first-file [e]
  (-> e .-target .-files (aget 0)))

(defn map-csv [csv]
  (let [[headers & lines] csv
        ; This is not very strict, which is fine for our use-case
        valid-month? #(some? (re-find #"[0-3][0-9]\.[0-1][0-9]\.[1-2][0-9]{3}" %))
        translated-header (map translate-header headers)
        lines->map (comp #(into {} %)
                    (fn [e] (filter #(seq (val %)) e))
                    #(zipmap (map keyword translated-header) %))]
    (->> lines
         (map lines->map)
         (group-by #(valid-month? (:date %))))))

(defn handle-reader-result [e file-data]
  (let [read-result (-> e .-target .-result)
        csv (file-parser read-result)]
    (reset! file-data (map-csv csv))))

(defn handle-csv-input [e file-data]
  (if (not= "" (-> e .-target .-value))
    (let [reader (js/FileReader.)]
      (.readAsText reader (get-first-file e))
      (set! (.-onload reader) #(handle-reader-result % file-data)))))

(defn input-component [file-data]
  [:div {:class "upload-button"}
   [:label {:style {:padding "5px" :display "block"}} "BROWSE"
    [:input
     {:type "file"
      :id "file"
      :accept ".csv"
      :name "file"
      :multiple true
      :style {:display "none"}
      :on-change #(handle-csv-input % file-data)}]]])

(defn top-bar [file-data]
  [:div {:style {:margin "20px"}}
   (input-component file-data)])
