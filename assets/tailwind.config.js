module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js",
  ],
  theme: {
    colors: {
      secondary: "#FC5868",
      primary: "#14134F",
      accent: "#FFB47C",
      light: "#EDF2FE",
      lighter: "#CFDCFB",
      gray: "#52555B",
      white: "#FFFFFF",
    },
    fontFamily: {
      sans: ["Red Hat Display", "sans-serif"],
      serif: ["Red Hat Display", "serif"],
    },
    extend: {},
  },
  variants: {},
  plugins: [require("@tailwindcss/forms")],
};
