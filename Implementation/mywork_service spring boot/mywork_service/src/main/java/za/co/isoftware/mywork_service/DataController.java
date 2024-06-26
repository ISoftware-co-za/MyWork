package za.co.isoftware.mywork_service;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

@RestController
@RequestMapping("/data")
public class DataController {

    @GetMapping
    public List<DataParent> list() {
        return new ArrayList<>(Arrays.asList(
                new DataParent(1, "name 1"),
                new DataParent(2, "name 2"),
                new DataParent(3, "name 3")
        ));
    }

    @GetMapping("/{id}")
    public DataChild data(@PathVariable int id) {
        return new DataChild(id, String.format("%s line 1", id), String.format("%s line 2",id), String.format("%s line 3", id));
    }
}
