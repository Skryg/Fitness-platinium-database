package com.tcs.project.Client;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.bind.annotation.CrossOrigin;

import java.util.List;

@Service
public class ClientService {

    private final ClientRepository clientRepository;

    @Autowired
    public ClientService(ClientRepository clientRepository) {
        this.clientRepository = clientRepository;
    }

    public List<Client> getClients() {
        return clientRepository.getClients();
    }

    public Client getClient(Long id) {
        return clientRepository.getClient(id);
    }

    public void addNewClient(Client client) {
        clientRepository.addNewClient(client.getName(), client.getSurname(), client.getAddress(), client.getPhone(), client.getEmail());
    }

    public void deleteClient(Long id) {
            clientRepository.deleteClientById(id);
    }

    public List<Object[]> getEntriesByClient(Long id) {
        return clientRepository.getEntriesByClient(id);
    }

    public List<Client> getClientsByGym(Long id) {
        return clientRepository.getClientsByGym(id);
    }

    public List<Object[]> getEntriesByGym(Long id) {
        return clientRepository.getEntriesByGym(id);
    }

    public List<Object[]> getChallenges() {
        return clientRepository.getChallenges();
    }

    public List<Object[]> getPersonByName(String name) {
        return clientRepository.getPersonByName(name);
    }

    public List<Object[]> giveAwards(int id) {
        return clientRepository.giveAwards(id);
    }

    public List<Object[]> canEnterGym(int id1, int id2) {
        return clientRepository.canEnterGym(id1, id2);
    }

    public void enterGym(int id1, int id2) {
        clientRepository.enterGym(id1, id2);
    }

    public void exitGym(int id1) {
        clientRepository.exitGym(id1);
    }
}