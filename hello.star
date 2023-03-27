load("render.star", "render")


def main(config):

    return render.Root (
        delay = 500,
        child = render.Box(
            color="00f",
            child=render.Box(
                width=20,
                height=10,
                color="#f00",
            )
        ),
    )