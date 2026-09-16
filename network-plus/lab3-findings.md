# Lab 3 Findings — Packet Capture & Protocol Analysis

## TCP 3-way handshake

Captured with tcpdump -i any -w capture1.pcap while running curl http://example.com.

1. [S]  172.24.247.76:54172 -> 104.20.23.154:80   seq=1281295160
2. [S.] 104.20.23.154:80 -> 172.24.247.76:54172   seq=2767061528, ack=1281295161
3. [.]  172.24.247.76:54172 -> 104.20.23.154:80   ack=1

Packet 1 (SYN): client sends SYN only, proposing seq 1281295160 as the start
of its byte stream.
Packet 2 (SYN-ACK): server responds with SYN+ACK. Its ack number is the client's
seq + 1, confirming receipt. The server also proposes its own starting seq.
Packet 3 (ACK): client ACKs the server's SYN. Connection is now open in both
directions, and every subsequent packet carries the ACK flag alongside any
data flags.

The connection closed gracefully with a 4-way FIN exchange at the end of the
capture: client FIN -> server ACK -> server FIN -> client ACK.

## DNS query and response

Captured with tcpdump -i any -nn -A port 53 while running dig example.com.

Query:    10.255.255.254 -> 10.255.255.254:53   "12546+ [1au] A? example.com."
Response: 10.255.255.254:53 -> 10.255.255.254   "12546 2/0/1 A 172.66.147.243, A 104.20.23.154"

Both packets share transaction ID 12546, that's how DNS matches a response to
its query, since UDP keeps no persistent connection state to track it any other
way. The ASCII dump also showed "example.com" in plaintext, confirming standard
DNS queries are unencrypted. Resolution happened entirely over loopback via the
local systemd-resolved stub resolver (10.255.255.254:53), never touching the
real network, dig reported a 40ms query time and explicitly labeled the
transport as UDP.

## Why DNS uses UDP but a file download uses TCP

DNS needs to be fast and involves a single small request/response, if a packet
gets lost, the client just asks again, and the tiny overhead of a lookup doesn't
justify a connection setup. TCP's download, by contrast, is transferring a
multi-packet response that must arrive complete, in order, and without
corruption. The 3-way handshake exists specifically to establish sequence
numbers and confirm both sides are ready before any data flows, so TCP can
guarantee ordered, reliable delivery, something UDP intentionally does not
provide, trading reliability for speed.
