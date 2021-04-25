(ns vihkonen.state
  (:require
   [reagent.core :as r]))

(def cache (r/atom {:file-data {}}))

(def file-data (r/cursor cache [:file-data]))
