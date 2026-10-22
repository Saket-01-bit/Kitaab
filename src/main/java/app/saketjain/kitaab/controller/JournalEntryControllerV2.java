package app.saketjain.kitaab.controller;

import app.saketjain.kitaab.entity.JournalEntry;
import app.saketjain.kitaab.service.JournalEntryService;
import org.bson.types.ObjectId;
import org.springframework.http.HttpStatus;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.PathVariable;


import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/journal")
@CrossOrigin(origins = {
        "http://localhost:5000",
        "http://localhost:3000",
        "http://localhost:8081"
})
public class JournalEntryControllerV2 {

    @Autowired
    private JournalEntryService journalEntryService;

    private final Map<Long, JournalEntry> journalEntries = new HashMap<>();

    @GetMapping
    public List<JournalEntry> getAll(){ //localhost:8080/journal GET
        return journalEntryService.getAll();
    }

    @GetMapping("/id/{myId}")
    public JournalEntry getEntryById(@PathVariable ObjectId myId){
        return journalEntryService.findById(myId).orElse(null);
    }

    @PostMapping
    public JournalEntry createJournalEntry(@RequestBody JournalEntry myEntry){ //localhost:8080/journal POST
        myEntry.setDate(LocalDateTime.now());
        journalEntryService.saveEntry(myEntry);
        return myEntry;
    }

    @DeleteMapping("/id/{myId}")
    public ResponseEntity<?> deleteJournalEntryById(
            @PathVariable String myId) {

        if (!ObjectId.isValid(myId)) {
            return ResponseEntity
                    .badRequest()
                    .body("Invalid journal entry ID");
        }

        journalEntryService.deleteById(new ObjectId(myId));

        return ResponseEntity.ok(true);
    }

    @PutMapping("/id/{myId}")
    public ResponseEntity<JournalEntry> updateJournalEntry(@PathVariable ObjectId myId, @RequestBody JournalEntry newEntry) {

        JournalEntry old = journalEntryService.findById(myId)
                .orElse(null);

        if (old == null) {
            return ResponseEntity.notFound().build();
        }

        if (newEntry.getTitle() != null
                && !newEntry.getTitle().isBlank()) {
            old.setTitle(newEntry.getTitle());
        }

        if (newEntry.getContent() != null
                && !newEntry.getContent().isBlank()) {
            old.setContent(newEntry.getContent());
        }

        journalEntryService.saveEntry(old);
        return ResponseEntity.ok(old);
    }
}
