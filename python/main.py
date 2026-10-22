# ============================================
# TEXT-BASED GRAPHICS SYSTEM
# High-Level Language Version - Python
# ============================================


# ANSI colour codes
RED = "\033[31m"
GREEN = "\033[32m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
WHITE = "\033[37m"
RESET = "\033[0m"


def get_choice(prompt, valid_choices):
    """
    Repeatedly asks the user for input until
    one of the allowed choices is entered.
    """

    while True:
        choice = input(prompt).strip()

        if choice in valid_choices:
            return choice

        print("Invalid input. Please try again.")


def draw_pyramid():

    print("\n--- Pyramid ---")

    # ========================================
    # HEIGHT
    # ========================================

    while True:
        height_input = input("Enter pyramid height (2-9): ").strip()

        if height_input.isdigit():
            height = int(height_input)

            if 2 <= height <= 9:
                break

        print("Invalid height. Enter a value from 2 to 9.")


    # ========================================
    # STYLE
    # ========================================

    print("\nSelect style:")
    print("1. Filled")
    print("2. Hollow")

    style = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )


    # ========================================
    # DRAWING CHARACTER
    # ========================================

    print("\nSelect drawing character:")
    print("1. *")
    print("2. #")

    char_choice = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )

    if char_choice == "1":
        draw_char = "*"
    else:
        draw_char = "#"


    # ========================================
    # COLOUR
    # ========================================

    print("\nSelect colour:")
    print("1. Red")
    print("2. Green")
    print("3. Yellow")
    print("4. Blue")
    print("5. Magenta")
    print("6. Cyan")
    print("7. White")

    colour_choice = get_choice(
        "Enter choice: ",
        ["1", "2", "3", "4", "5", "6", "7"]
    )

    colours = {
        "1": RED,
        "2": GREEN,
        "3": YELLOW,
        "4": BLUE,
        "5": MAGENTA,
        "6": CYAN,
        "7": WHITE
    }

    colour = colours[colour_choice]


    # ========================================
    # GENERATE PYRAMID
    # ========================================

    print()

    for row in range(1, height + 1):

        spaces = height - row
        width = (2 * row) - 1

        print(" " * spaces, end="")
        print(colour, end="")

        # FILLED
        if style == "1":

            print(draw_char * width, end="")

        # HOLLOW
        else:

            for position in range(width):

                first_position = position == 0
                last_position = position == width - 1
                bottom_row = row == height

                if first_position or last_position or bottom_row:
                    print(draw_char, end="")
                else:
                    print(" ", end="")

        print(RESET)

def draw_rectangle():

    print("\n--- Rectangle ---")

    # ========================================
    # WIDTH
    # ========================================

    while True:
        width_input = input("Enter rectangle width (2-20): ").strip()

        if width_input.isdigit():
            width = int(width_input)

            if 2 <= width <= 20:
                break

        print("Invalid width. Enter a value from 2 to 20.")


    # ========================================
    # HEIGHT
    # ========================================

    while True:
        height_input = input("Enter rectangle height (2-10): ").strip()

        if height_input.isdigit():
            height = int(height_input)

            if 2 <= height <= 10:
                break

        print("Invalid height. Enter a value from 2 to 10.")


    # ========================================
    # STYLE
    # ========================================

    print("\nSelect style:")
    print("1. Solid")
    print("2. Hollow")

    style = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )


    # ========================================
    # DRAWING CHARACTER
    # ========================================

    print("\nSelect drawing character:")
    print("1. *")
    print("2. #")

    char_choice = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )

    if char_choice == "1":
        draw_char = "*"
    else:
        draw_char = "#"


    # ========================================
    # GENERATE RECTANGLE
    # ========================================

    print()

    for row in range(height):

        for column in range(width):

            # Solid rectangle
            if style == "1":
                print(draw_char, end="")

            # Hollow rectangle
            else:

                top_row = row == 0
                bottom_row = row == height - 1
                left_column = column == 0
                right_column = column == width - 1

                if top_row or bottom_row or left_column or right_column:
                    print(draw_char, end="")
                else:
                    print(" ", end="")

        print()

def draw_triangle():

    print("\n--- Triangle ---")

    # HEIGHT
    while True:
        height_input = input("Enter triangle height (2-9): ").strip()

        if height_input.isdigit():
            height = int(height_input)

            if 2 <= height <= 9:
                break

        print("Invalid height. Enter a value from 2 to 9.")


    # STYLE
    print("\nSelect style:")
    print("1. Filled")
    print("2. Hollow")

    style = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )


    # DRAWING CHARACTER
    draw_char = input("Enter one character to draw with: ").strip()

    while len(draw_char) != 1:
        print("Invalid character. Enter exactly one character.")
        draw_char = input("Enter one character to draw with: ").strip()


    # COLOUR
    print("\nSelect colour:")
    print("1. Red")
    print("2. Green")
    print("3. Yellow")
    print("4. Blue")
    print("5. Magenta")
    print("6. Cyan")

    colour_choice = get_choice(
        "Enter choice: ",
        ["1", "2", "3", "4", "5", "6"]
    )

    colours = {
        "1": RED,
        "2": GREEN,
        "3": YELLOW,
        "4": BLUE,
        "5": MAGENTA,
        "6": CYAN
    }

    colour = colours[colour_choice]


    # GENERATE TRIANGLE
    print()

    for row in range(1, height + 1):

        print(colour, end="")

        # Filled
        if style == "1":
            print(draw_char * row, end="")

        # Hollow
        else:
            for column in range(1, row + 1):

                left_edge = column == 1
                right_edge = column == row
                bottom_row = row == height

                if left_edge or right_edge or bottom_row:
                    print(draw_char, end="")
                else:
                    print(" ", end="")

        print(RESET)
def draw_diamond():

    print("\n--- Diamond ---")

    # ========================================
    # SIZE
    # ========================================

    while True:
        size_input = input("Enter diamond size (2-9): ").strip()

        if size_input.isdigit():
            size = int(size_input)

            if 2 <= size <= 9:
                break

        print("Invalid size. Enter a value from 2 to 9.")


    # ========================================
    # QUANTITY
    # ========================================

    while True:
        quantity_input = input("Enter number of diamonds (1-9): ").strip()

        if quantity_input.isdigit():
            quantity = int(quantity_input)

            if 1 <= quantity <= 9:
                break

        print("Invalid quantity. Enter a value from 1 to 9.")


    # ========================================
    # STYLE
    # ========================================

    print("\nSelect style:")
    print("1. Filled")
    print("2. Hollow")

    style = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )


    # ========================================
    # DRAWING CHARACTER
    # ========================================

    print("\nSelect drawing character:")
    print("1. *")
    print("2. #")

    char_choice = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )

    if char_choice == "1":
        draw_char = "*"
    else:
        draw_char = "#"


    # ========================================
    # COLOUR
    # ========================================

    print("\nSelect colour:")
    print("1. Red")
    print("2. Green")
    print("3. Yellow")
    print("4. Blue")
    print("5. Magenta")
    print("6. Cyan")
    print("7. White")

    colour_choice = get_choice(
        "Enter choice: ",
        ["1", "2", "3", "4", "5", "6", "7"]
    )

    colours = {
        "1": RED,
        "2": GREEN,
        "3": YELLOW,
        "4": BLUE,
        "5": MAGENTA,
        "6": CYAN,
        "7": WHITE
    }

    colour = colours[colour_choice]


    # ========================================
    # GENERATE DIAMOND
    # ========================================

    print()

    for diamond_number in range(quantity):

        # -----------------------------
        # UPPER HALF
        # -----------------------------

        for row in range(1, size + 1):

            spaces = size - row
            width = (2 * row) - 1

            print(" " * spaces, end="")
            print(colour, end="")

            if style == "1":
                print(draw_char * width, end="")

            else:
                for position in range(width):

                    first_position = position == 0
                    last_position = position == width - 1

                    if first_position or last_position:
                        print(draw_char, end="")
                    else:
                        print(" ", end="")

            print(RESET)


        # -----------------------------
        # LOWER HALF
        # -----------------------------

        for row in range(size - 1, 0, -1):

            spaces = size - row
            width = (2 * row) - 1

            print(" " * spaces, end="")
            print(colour, end="")

            if style == "1":
                print(draw_char * width, end="")

            else:
                for position in range(width):

                    first_position = position == 0
                    last_position = position == width - 1

                    if first_position or last_position:
                        print(draw_char, end="")
                    else:
                        print(" ", end="")

            print(RESET)

        if diamond_number < quantity - 1:
            print()
def draw_xshape():

    print("\n--- X Shape ---")

    # ========================================
    # SIZE
    # ========================================

    while True:
        size_input = input("Enter X size (3-9): ").strip()

        if size_input.isdigit():
            size = int(size_input)

            if 3 <= size <= 9:
                break

        print("Invalid size. Enter a value from 3 to 9.")


    # ========================================
    # THICKNESS
    # ========================================

    print("\nSelect thickness:")
    print("1. Normal")
    print("2. Thick")

    thickness = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )


    # ========================================
    # DRAWING CHARACTER
    # ========================================

    print("\nSelect drawing character:")
    print("1. *")
    print("2. #")

    char_choice = get_choice(
        "Enter choice: ",
        ["1", "2"]
    )

    if char_choice == "1":
        draw_char = "*"
    else:
        draw_char = "#"


    # ========================================
    # COLOUR
    # ========================================

    print("\nSelect colour:")
    print("1. Red")
    print("2. Green")
    print("3. Yellow")
    print("4. Blue")
    print("5. Magenta")
    print("6. Cyan")
    print("7. White")

    colour_choice = get_choice(
        "Enter choice: ",
        ["1", "2", "3", "4", "5", "6", "7"]
    )

    colours = {
        "1": RED,
        "2": GREEN,
        "3": YELLOW,
        "4": BLUE,
        "5": MAGENTA,
        "6": CYAN,
        "7": WHITE
    }

    colour = colours[colour_choice]


    # ========================================
    # GENERATE X
    # ========================================

    print()

    for row in range(size):

        opposite_diagonal = (size - 1) - row

        print(colour, end="")

        for column in range(size):

            # Main diagonal
            on_main_diagonal = column == row

            # Opposite diagonal
            on_opposite_diagonal = column == opposite_diagonal


            # NORMAL X
            if thickness == "1":

                if on_main_diagonal or on_opposite_diagonal:
                    print(draw_char, end="")
                else:
                    print(" ", end="")


            # THICK X
            else:

                beside_main_diagonal = (
                    column == row - 1
                    or column == row + 1
                )

                beside_opposite_diagonal = (
                    column == opposite_diagonal - 1
                    or column == opposite_diagonal + 1
                )

                if (
                    on_main_diagonal
                    or on_opposite_diagonal
                    or beside_main_diagonal
                    or beside_opposite_diagonal
                ):
                    print(draw_char, end="")
                else:
                    print(" ", end="")

        print(RESET)
def main():

    while True:

        print("\n==============================")
        print("     TEXT GRAPHICS SYSTEM")
        print("==============================")
        print("1. Pyramid")
        print("2. Rectangle")
        print("3. Triangle")
        print("4. Diamond")
        print("5. X Shape")
        print("6. Exit")

        choice = input("Enter choice: ").strip()

        if choice == "1":
            draw_pyramid()

        elif choice == "2":
            draw_rectangle()

        elif choice == "3":
            draw_triangle()

        elif choice == "4":
            draw_diamond()

        elif choice == "5":
            draw_xshape()

        elif choice == "6":
            print("Program exited.")
            break


        else:
            print("Invalid choice. Please enter 1-6.")


# Program starts here
main()
