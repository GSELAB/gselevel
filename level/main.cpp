/*
 * Copyright (c) 2018 GSENetwork
 *
 * This file is part of GSENetwork.
 *
 * GSENetwork is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 3 of the License, or any later version.
 *
 */

#include <beast/http.hpp>
#include <beast/core.hpp>
#include <beast/version.hpp>
#include <boost/asio/connect.hpp>
#include <boost/asio/ip/tcp.hpp>
#include <cstdlib>
#include <iostream>
#include <string>
#include <vector>

#include <client/Http.h>
#include <core/Address.h>
#include <core/Log.h>
#include <utils/Utils.h>

using namespace std;
using namespace client;
using namespace core;
using namespace utils;

#define MAX_RECIPIENTS 1024

Address getRandomAddress()
{

    static std::vector<Address> recipients;
    if (recipients.size() < MAX_RECIPIENTS) {
        GKey key = GKey::create();
        recipients.push_back(key.getAddress());
        return key.getAddress();
    }

    int64_t timestamp = currentTimestamp();
    unsigned index = (unsigned) (timestamp % MAX_RECIPIENTS);
    return recipients[index];
}

int main(int argc, char **argv)
{
    CINFO << "GSENetwork Level!" << std::endl;

    std::string default_host = "132.232.52.156";
    std::string default_port = "50505";
    int default_version = 11;

    client::Client client(default_host, default_port, default_version);
    client.login("63D065F2D813D790427C8583E384359828BFF6A9F7012F9D28C111D7F2A2EF88");

    uint64_t count = 0;
    for (count = 1; count > 0; count++) {

        unsigned txSize = count % 5;
        for (unsigned i = 0; i < txSize; i++) {
            uint64_t value = currentTimestamp() % 10000000;
            Address recipient = getRandomAddress();
            CINFO << "[" << count << ":" << i << "] Send to:" << recipient << "  value:" << value;
            client.transfer("/create_transaction", recipient, value);
        }

        if (currentTimestamp() % 2) {
            sleepMilliseconds(3000);
        } else {
            sleepMilliseconds(1500);
        }

    }

    return 0;
}
