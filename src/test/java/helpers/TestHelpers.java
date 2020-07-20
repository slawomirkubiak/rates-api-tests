package helpers;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.temporal.ChronoField;
import java.time.temporal.ChronoUnit;
import java.util.Collections;
import java.util.List;

import static org.junit.Assert.assertEquals;

public class TestHelpers {
    public static LocalDate getPreviousWorkingDay(LocalDate date) {
        DayOfWeek dayOfWeek = DayOfWeek.of(date.get(ChronoField.DAY_OF_WEEK));
        switch (dayOfWeek) {
            case MONDAY:
                return date.minus(3, ChronoUnit.DAYS);
            case SUNDAY:
                return date.minus(2, ChronoUnit.DAYS);
            default:
                return date.minus(1, ChronoUnit.DAYS);
        }
    }

    public static void compareListsIfEquals(List<String> list1, List<String> list2) {
        Collections.sort(list1);
        Collections.sort(list2);
        assertEquals(list1, list2);
    }
}
