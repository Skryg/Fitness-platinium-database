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
        return clientRepository.findAll();
    }

    public Client getClient(Long id) {
        return clientRepository.findById(id).orElseThrow(
                () -> new IllegalStateException("Client with id " + id + " does not exists"));
    }

    public void addNewClient(Client client) {
        clientRepository.save(client);
    }

    public void deleteClient(Long id) {
        boolean exists = clientRepository.existsById(id);
        if (!exists) {
            throw new IllegalStateException("Client with id " + id + " does not exists");
        }
        clientRepository.deleteById(id);
    }


}