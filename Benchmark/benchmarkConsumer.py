from pykafka import KafkaClient
import time
import sys

msg_size = 100
bootstrap_servers = "broker:9092"
producer_timings = {}
consumer_timings = {}


def calculate_thoughput(timing, n_messages, msg_size=100):
    print("Processed {0} messsages in {1:.2f} seconds".format(n_messages, timing))
    print("{0:.2f} MB/s".format((msg_size * n_messages) / timing / (1024 * 1024)))
    print("{0:.2f} Msgs/s".format(n_messages / timing))


def benchmark(consumer, duration):
    # producer.block_on_queue_full(True)

    msgs_consumed = 0
    consume_start = time.time()

    while True:
        # Start consuming
        consumer.consume()
        msgs_consumed += 1
        if msgs_consumed % 100 == 0:
            curr_time = time.time()
            if curr_time - consume_start >= duration:
                print("Benchmark time is over: exiting")
                break

    print("Finished consuming... now calculating results...")

    return (curr_time - consume_start, msgs_consumed)


def test_consume(consumer):
    #    producer.block_on_queue_full(True)
    for i in range(5):
        # Start producing
        msg = consumer.consume()
        print("Consumed message {0}:{1}. Size: {2}\n".format(i, msg, len(msg)))

    print("Finished consuming test messages. Next: BENCHMARK")
    # producer.stop()  # Will flush background queue


def main(topic, bootstrap_server, exec_time=60):
    client = KafkaClient(hosts=bootstrap_server)
    print("Created client!")
    # topic = client.topics[b"bench"]
    topic = client.topics[bytes(topic, encoding="utf-8")]
    print("Created topic link!")
    consumer = topic.get_simple_consumer()
    print("Created consumer object!")

    test_consume(consumer)
    # input("Press ENTER to start benchmarking for {0}ms".format(exec_time))
    totalTime, messages = benchmark(consumer, exec_time)
    calculate_thoughput(totalTime, messages)


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2], int(sys.argv[3]))
