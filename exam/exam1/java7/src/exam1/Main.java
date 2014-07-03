/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package exam1;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author nomura_y
 */
public class Main {

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        if (args.length < 2) {
            System.err.println("Usage: Main [123] inputfile");
            return;
        }
        String mode = args[0];
        String file = args[1];
        try (BufferedReader r = new BufferedReader(new FileReader(file))) {
            Map<String, Integer> result = new HashMap<>();
            String line;
            while ((line = r.readLine()) != null) {
                if ("".equals(line)) continue;

                for (String word : line.split("[^a-zA-Z]+")) {
                    String key = word.toLowerCase();
                    Integer i = result.get(key);
                    i = i == null ? 1 : i + 1;
                    result.put(key, i);
                }
            }

            List<Entry<String, Integer>> rs = toList(result.entrySet());
            Collections.sort(rs, new Comparator<Entry<String, Integer>>() {
                @Override
                public int compare(Entry<String, Integer> a, Entry<String, Integer> b) {
                    return b.getValue().compareTo(a.getValue());
                }
            });
            for (Entry<String, Integer> v : rs) {
                System.out.printf("%s: %d\n", v.getKey(), v.getValue());
            }
        } catch (IOException ex) {
            Logger.getLogger(Main.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private static <T> List<T> toList(Iterable<T> it) {
        ArrayList<T> ret = new ArrayList<>();
        for (T t : it) {
            ret.add(t);
        }
        return ret;
    }

}
