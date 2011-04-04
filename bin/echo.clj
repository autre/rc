
(defn -main [args]
  (doseq [arg args]
    (println arg)))

(-main (rest *command-line-args*))

