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
        clientRepository.deleteGymEntryByClientId(id);
        clientRepository.deleteClientById(id);
        clientRepository.deletePersonById(id);
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




}