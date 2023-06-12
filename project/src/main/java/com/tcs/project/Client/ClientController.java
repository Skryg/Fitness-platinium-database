package com.tcs.project.Client;


import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/client")
@CrossOrigin(origins = "http://localhost:4200")
public class ClientController {
    private final ClientService clientService;

    public ClientController(ClientService clientService) {
        this.clientService = clientService;
    }
    @GetMapping
    public List<Client> getClients() {
        return clientService.getClients();
    }

    @GetMapping("/{id}")
    public Client getClient(@PathVariable Long id) {
        return clientService.getClient(id);
    }

    @DeleteMapping("/{id}")
    public void deleteClient(@PathVariable Long id) {
        clientService.deleteClient(id);
    }

    @PostMapping
    public void addNewClient(@RequestBody Client client) {
        clientService.addNewClient(client);

    }

    @GetMapping("/entries/{id}")
    @CrossOrigin(origins = "http://localhost:4200")
    public List<Object[]> getEntriesByClient(@PathVariable Long id) {
        return clientService.getEntriesByClient(id);
    }

    @GetMapping("/gym/{id}")
    public List<Client> getClientsByGym(@PathVariable Long id) {
        return clientService.getClientsByGym(id);
    }

    @GetMapping("/entries/gym/{id}")
    public List<Object[]> getEntriesByGym(@PathVariable Long id) {
        return clientService.getEntriesByGym(id);
    }

    @GetMapping("challenge")
    public List<Object[]> getChallenges() {
        return clientService.getChallenges();
    }


}