# Lab 3: Packet Capture & Protocol Analysis

**Network+ objectives covered:** 1.4 (protocols/ports), 5.2 (troubleshooting),
2.1 (protocol behavior — TCP handshake, DNS, HTTP)

## Exercises

1. **Capture your own traffic**
   ```bash
   sudo tcpdump -i any -w capture1.pcap &
   curl http://example.com
   sudo kill %1
   ```

2. **Read it back and identify the TCP 3-way handshake**
   ```bash
   tcpdump -r capture1.pcap -nn | head -20
   ```
   Find the SYN, SYN-ACK, ACK sequence. Write down the source/dest ports and
   note that the client picked an ephemeral high port while the server used 80.

3. **Filter by protocol**
   ```bash
   sudo tcpdump -i any -nn port 53          # DNS only
   sudo tcpdump -i any -nn icmp             # ping traffic
   sudo tcpdump -i any -nn tcp and port 443 # HTTPS handshake
   ```

4. **Analyze a DNS query on the wire**
   ```bash
   sudo tcpdump -i any -nn -A port 53 &
   dig example.com
   sudo kill %1
   ```
   Identify the query and response packets, and note the UDP transport.

## Deliverable

`network-plus/lab3-findings.md` containing:
- Annotated hex/ASCII snippet of a TCP handshake (3 packets, labeled SYN/SYN-ACK/ACK)
- One DNS query/response pair explained
- A one-paragraph explanation, in your own words, of why DNS uses UDP but a
  file download uses TCP
