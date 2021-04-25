(ns vihkonen.core
  (:require
   [vihkonen.config :as config]
   [vihkonen.state :as state]
   [vihkonen.components.input :refer [top-bar]]
   [vihkonen.components.main :refer [main-container]]
   [reagent.debug :as debug]
   [reagent.dom :as d])
  (:import [goog.labs.format csv]
           [goog.labs.format.csv ParseError]))

(defn home-page []
  [:div
   [top-bar state/file-data]
   [main-container @state/file-data]])

(defn ^:dev/after-load mount-root []
  (let [root-el (.getElementById js/document "app")]
    (d/render [home-page] root-el)))

(defn init []
  (when config/debug?
    (debug/warn "Running in debug mode"))
  (mount-root))
