def main():
    try:
        import at_client
        print("atsdk dependnecy is valid!")
    except Exception as error:
        print("atsdk is invalid: ", error)

if __name__ == "__main__":
    main()
