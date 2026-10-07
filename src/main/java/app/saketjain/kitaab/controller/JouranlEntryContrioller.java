package app.saketjain.kitaab.controller;

import app.saketjain.kitaab.entity.JournalEntry;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/journal")
public class JouranlEntryContrioller {

    private Map<Long, JournalEntry> journalEnteries = new HashMap<>();

    @GetMapping
    public List<JournalEntry> getAll(){ //localhost:8080/journal GET
        return new ArrayList<>(journalEnteries.values());
    }

    @GetMapping("/id/{myId}")
    public JournalEntry getEntryById(@PathVariable long myId){
        return journalEnteries.get(myId);
    }

    @PostMapping
    public JournalEntry createJournalEntry(@RequestBody JournalEntry myEntry){ //localhost:8080/journal POST
        journalEnteries.put(myEntry.getId(), myEntry);
        return myEntry;
    }

    @DeleteMapping("/id/{myId}")
    public boolean deleteEntryById(@PathVariable long myId){
        return  journalEnteries.remove(myId) != null;
    }

    @PutMapping("/id/{myId}")
    public JournalEntry updateJournalEntry(@PathVariable long myId, @RequestBody JournalEntry myEntry){
        return journalEnteries.put(myId, myEntry);
    }
}
