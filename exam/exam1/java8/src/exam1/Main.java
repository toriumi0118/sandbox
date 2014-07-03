
package exam1;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;
import java.util.stream.Stream;

public class Main {
    public static void main(String[] args) {
        if (args.length < 2) {
            System.err.println("Usage: Main [123] inputfile");
            return;
        }
        String mode = args[0];
        String file = args[1];
        Function<String, Stream<?>> f = selectMode(mode);
        try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
            Map<Object, Integer> result = new HashMap<>();
            reader
                    .lines()
                    .filter(s -> !"".equals(s))
                    .flatMap(f)
                    .forEach(s -> result.put(s, result.getOrDefault(s, 0) + 1));

            result.entrySet().stream()
                    .sorted((a, b) -> b.getValue().compareTo(a.getValue()))
                    .forEach(r -> System.out.printf("%s: %d\n", r.getKey(), r.getValue()));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private static Function<String, Stream<?>> selectMode(String mode) {
        switch (mode) {
            case "1":
                return s -> Stream.of(s.split("[^a-zA-Z]+"))
                        .map(s1 -> s1.toLowerCase());
            case "2":
                return s -> s.chars()
                        .boxed()
                        .map(i -> new Character((char) i.intValue()))
                        .filter(c -> Character.isLetter(c))
                        .map(c -> Character.toLowerCase(c));
            case "3":
                return s -> Stream.of(s.split("[^a-zA-Z]+"))
                        .map(s1 -> Character.toLowerCase(s1.charAt(0)));
            default:
                throw new IllegalArgumentException("unknown mode=" + mode);
        }
    }
}
