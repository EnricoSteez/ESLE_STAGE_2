from pykafka import KafkaClient, partitioners
import time
import sys

msg_size = 100
msg_payload = ("benchmark " * 20).encode()[:msg_size]
producer_timings = {}
consumer_timings = {}


def calculate_thoughput(timing, n_messages, msg_size=100):
    print("Processed {0} messsages in {1:.2f} seconds".format(n_messages, timing))
    print("{0:.2f} MB/s".format((msg_size * n_messages) / timing / (1024 * 1024)))
    print("{0:.2f} Msgs/s".format(n_messages / timing))


def benchmark(producer, duration=60):
    # producer.block_on_queue_full(True)

    msgs_produced = 0
    produce_start = time.time()

    while True:
        # Start producing
        producer.produce(msg_payload)
        msgs_produced += 1
        if msgs_produced % 100 == 0:
            curr_time = time.time()
            if curr_time - produce_start >= duration:
                print("Expired: exiting")
                break

    print("Finished producing... now calculating results...")
    producer.stop()  # Will flush background queue

    return (curr_time - produce_start, msgs_produced)


def test_produce(producer):
    #    producer.block_on_queue_full(True)
    print("Will produce 5 test messages")
    for i in range(5):
        # Start producing
        producer.produce(msg_payload)
        # print("Produced message {0}\n".format(i))

    print("Finished producing test messages. Next: BENCHMARK")
    # producer.stop()  # Will flush background queue


def main(topic, bootstrap_server, exec_time):
    client = KafkaClient(hosts=bootstrap_server)
    print("Created client!")
    # topic = client.topics[b"bench"]
    topic = client.topics[bytes(topic, encoding="utf-8")]
    print("Created topic link!")
    producer = topic.get_producer(use_rdkafka=False)
    print("Created producer object!")

    test_produce(producer)
    # input("Press ENTER to start benchmarking for {0}ms".format(exec_time))
    totalTime, messages = benchmark(producer, exec_time)
    calculate_thoughput(totalTime, messages)


if __name__ == "__main__":
    main(topic=sys.argv[1], bootstrap_server=sys.argv[2], exec_time=int(sys.argv[3]))
